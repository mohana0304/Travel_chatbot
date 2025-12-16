import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

// Message Model
class Message {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  Message({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

// Chat Provider
class ChatProvider with ChangeNotifier {
  List<Message> _messages = [
    Message(
      text: "Hello! I'm **TripTalk – Your AI Travel Assistant!** 🌍\n\nI can provide detailed travel information about ANY destination including:\n• Best places to visit with descriptions\n• Local foods to try\n• Budget breakdown\n• Custom itineraries\n\nJust type any city, country, or place name!",
      isUser: false,
      timestamp: DateTime.now(),
    )
  ];

  List<Message> get messages => _messages;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void addMessage(Message message) {
    _messages.add(message);
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;

    // Add user message
    final userMessage = Message(
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    addMessage(userMessage);
    setLoading(true);

    try {
      final response = await ChatService.getGuaranteedTravelResponse(text);
      final aiMessage = Message(
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      );
      addMessage(aiMessage);
    } catch (e) {
      final errorMessage = Message(
        text: "Sorry, I'm having trouble. Please try again.",
        isUser: false,
        timestamp: DateTime.now(),
      );
      addMessage(errorMessage);
    } finally {
      setLoading(false);
    }
  }
}

// Travel Service with Guaranteed AI Responses
class ChatService {
  // Your API Keys
  static const String openRouterApiKey = '';
  static const String openWeatherApiKey = '';

  static Future<String> getGuaranteedTravelResponse(String userMessage) async {
    // Try multiple AI models until we get a response
    String? travelGuide;
    
    // Try Mistral first
    try {
      travelGuide = await _getTravelGuideWithMistral(userMessage);
    } catch (e) {
      print("Mistral failed: $e");
    }
    
    // If Mistral fails, try Gemini
    if (travelGuide == null) {
      try {
        travelGuide = await _getTravelGuideWithGemini(userMessage);
      } catch (e) {
        print("Gemini failed: $e");
      }
    }
    
    // If both AI models fail, use direct API call
    if (travelGuide == null) {
      travelGuide = await _getDirectTravelGuide(userMessage);
    }
    
    // Get weather info
    final weatherInfo = await _getCurrentWeather(userMessage);
    
    return "$travelGuide\n\n$weatherInfo";
  }

  static Future<String> _getTravelGuideWithMistral(String userMessage) async {
    final response = await http.post(
      Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $openRouterApiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'mistralai/mistral-7b-instruct:free',
        'messages': [
          {
            'role': 'user', 
            'content': 'Provide comprehensive travel guide for $userMessage with these sections: Best Places to Visit (with specific names and descriptions), Best Foods to Try (with specific local dishes), Budget Guide (with local currency estimates). Use bullet points and be specific.'
          },
        ],
        'max_tokens': 2000,
        'temperature': 0.8,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Mistral API failed with status: ${response.statusCode}');
    }
  }

  static Future<String> _getTravelGuideWithGemini(String userMessage) async {
    final response = await http.post(
      Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $openRouterApiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'google/gemini-pro-1.5',
        'messages': [
          {
            'role': 'user', 
            'content': 'Create detailed travel guide for $userMessage including: 1) Top 5-6 specific attractions with descriptions 2) Local foods to try 3) Budget breakdown in local currency. Be specific with actual place names and food names.'
          },
        ],
        'max_tokens': 2000,
        'temperature': 0.9,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Gemini API failed with status: ${response.statusCode}');
    }
  }

  static Future<String> _getDirectTravelGuide(String userMessage) async {
    // Simple direct API call without complex formatting
    final response = await http.post(
      Uri.parse('https://openrouter.ai/api/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $openRouterApiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'mistralai/mistral-7b-instruct:free',
        'messages': [
          {
            'role': 'user', 
            'content': 'Tell me about travel in $userMessage - places to visit, food to eat, and costs'
          },
        ],
        'max_tokens': 1500,
        'temperature': 0.7,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      // If everything fails, return a basic template
      return """
🌆 Travel Guide for ${userMessage.toUpperCase()}

🏛️ TOP ATTRACTIONS:
• Explore the main historical and cultural sites
• Visit local markets and shopping areas
• Enjoy natural parks and scenic spots
• Experience local museums and galleries
• Discover hidden gems and local neighborhoods

🍛 LOCAL CUISINE:
• Try traditional local dishes
• Experience street food culture
• Taste regional specialties
• Enjoy local beverages and desserts

💸 BUDGET ESTIMATES:
• Budget travel: Affordable options available
• Mid-range: Comfortable accommodations and dining
• Luxury: Premium experiences available

*Note: For specific current information, check official tourism websites.*
""";
    }
  }

  static Future<String> _getCurrentWeather(String placeName) async {
    try {
      // Clean the place name
      final cleanPlace = placeName.replaceAll(RegExp(r'\d+\s*day', caseSensitive: false), '')
                                .replaceAll('itinerary', '')
                                .replaceAll('trip', '')
                                .replaceAll('plan', '')
                                .trim();

      if (cleanPlace.isEmpty) return '';

      print("Getting weather for: $cleanPlace");
      
      final geoResponse = await http.get(
        Uri.parse('http://api.openweathermap.org/geo/1.0/direct?q=${Uri.encodeComponent(cleanPlace)}&limit=1&appid=$openWeatherApiKey'),
      );

      print("Geocoding response: ${geoResponse.statusCode}");
      
      if (geoResponse.statusCode == 200) {
        final geoData = jsonDecode(geoResponse.body);
        print("Geocoding data: $geoData");
        
        if (geoData.isNotEmpty) {
          final lat = geoData[0]['lat'];
          final lon = geoData[0]['lon'];
          final locationName = geoData[0]['name'] ?? cleanPlace;

          final weatherResponse = await http.get(
            Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$openWeatherApiKey&units=metric'),
          );

          print("Weather response: ${weatherResponse.statusCode}");
          
          if (weatherResponse.statusCode == 200) {
            final weatherData = jsonDecode(weatherResponse.body);
            final temp = weatherData['main']['temp'].round();
            final description = weatherData['weather'][0]['description'];
            final humidity = weatherData['main']['humidity'];
            final feelsLike = weatherData['main']['feels_like'].round();
            
            return "🌤️ Current Weather in ${locationName.toUpperCase()}\n"
                   "• Temperature: $temp°C (Feels like $feelsLike°C)\n"
                   "• Conditions: ${_capitalize(description)}\n"
                   "• Humidity: $humidity%";
          }
        }
      }
      return "🌤️ Weather data currently unavailable";
    } catch (e) {
      print("Weather error: $e");
      return "🌤️ Weather service temporarily unavailable";
    }
  }

  static String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}

// Galaxy Background Widget
class GalaxyBackground extends StatelessWidget {
  final Widget child;

  const GalaxyBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0A0A2A),
            Color(0xFF1A1A3A),
            Color(0xFF2A1B52),
          ],
          stops: [0.0, 0.6, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Animated stars
          _AnimatedStars(),
          // Nebula effect
          _NebulaEffect(),
          child,
        ],
      ),
    );
  }
}

class _AnimatedStars extends StatefulWidget {
  @override
  __AnimatedStarsState createState() => __AnimatedStarsState();
}

class __AnimatedStarsState extends State<_AnimatedStars>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Star> _stars = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 20),
    )..repeat();

    // Initialize stars
    for (int i = 0; i < 50; i++) {
      _stars.add(Star(
        offset: Offset(
          _random.nextDouble() * 1,
          _random.nextDouble() * 1,
        ),
        size: _random.nextDouble() * 2 + 1,
        speed: _random.nextDouble() * 0.5 + 0.1,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: StarPainter(_stars, _controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class Star {
  final Offset offset;
  final double size;
  final double speed;

  Star({required this.offset, required this.size, required this.speed});
}

class StarPainter extends CustomPainter {
  final List<Star> stars;
  final double animationValue;

  StarPainter(this.stars, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    for (final star in stars) {
      final x = (star.offset.dx + animationValue * star.speed) % 1.0;
      final y = star.offset.dy;
      final opacity = 0.5 + 0.5 * sin(animationValue * 2 * pi * star.speed);

      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        star.size,
        paint..color = Colors.white.withOpacity(opacity * 0.8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _NebulaEffect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topRight,
          radius: 1.5,
          colors: [
            Color(0xFF6A11CB).withOpacity(0.3),
            Color(0xFF2575FC).withOpacity(0.2),
            Colors.transparent,
          ],
          stops: [0.1, 0.5, 1.0],
        ),
      ),
    );
  }
}

// UI Components
class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      Provider.of<ChatProvider>(context, listen: false).sendMessage(text);
      _textController.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.travel_explore, color: Colors.white, size: 24),
            SizedBox(width: 8),
            Text(
              'TripTalk',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF6A11CB).withOpacity(0.8),
                Color(0xFF2575FC).withOpacity(0.6),
              ],
            ),
          ),
        ),
      ),
      body: GalaxyBackground(
        child: Column(
          children: [
            _buildApiStatus(),
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, chatProvider, child) {
                  WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: chatProvider.messages.length + (chatProvider.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < chatProvider.messages.length) {
                        return _buildMessage(chatProvider.messages[index]);
                      } else {
                        return _buildTypingIndicator();
                      }
                    },
                  );
                },
              ),
            ),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildApiStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF00B4DB).withOpacity(0.3),
            Color(0xFF0083B0).withOpacity(0.3),
          ],
        ),
        border: Border.all(color: Colors.cyan.withOpacity(0.5), width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(Icons.rocket_launch, color: Colors.cyan, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '🚀 TripTalk AI - Multiple AI models for guaranteed responses',
              style: TextStyle(
                color: Colors.cyan,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(Message message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF6A11CB),
                    Color(0xFF2575FC),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF6A11CB).withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(Icons.travel_explore, color: Colors.white, size: 18),
                radius: 16,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: message.isUser 
                  ? CrossAxisAlignment.end 
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: message.isUser 
                        ? LinearGradient(
                            colors: [
                              Color(0xFF6A11CB),
                              Color(0xFF2575FC),
                            ],
                          )
                        : LinearGradient(
                            colors: [
                              Color(0xFF2A1B52).withOpacity(0.8),
                              Color(0xFF1A1A3A).withOpacity(0.8),
                            ],
                          ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: message.isUser 
                          ? Colors.purpleAccent.withOpacity(0.3)
                          : Colors.blueAccent.withOpacity(0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: SelectableText(
                    message.text,
                    style: TextStyle(
                      color: message.isUser ? Colors.white : Colors.white70,
                      height: 1.4,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white54,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF11998e),
                    Color(0xFF38ef7d),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF11998e).withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(Icons.person, color: Colors.white, size: 18),
                radius: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF6A11CB),
                  Color(0xFF2575FC),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Icon(Icons.travel_explore, color: Colors.white, size: 18),
              radius: 16,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF2A1B52).withOpacity(0.8),
                  Color(0xFF1A1A3A).withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.blueAccent.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildAnimatedDot(0),
                _buildAnimatedDot(1),
                _buildAnimatedDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedDot(int index) {
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.cyan,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Color(0xFF1A1A3A).withOpacity(0.9),
          ],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF2A1B52).withOpacity(0.8),
                    Color(0xFF1A1A3A).withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.purpleAccent.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _textController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Ask about any destination...',
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  prefixIcon: Icon(Icons.travel_explore, color: Colors.white54),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: chatProvider.isLoading 
                      ? LinearGradient(
                          colors: [
                            Colors.grey.withOpacity(0.6),
                            Colors.grey.withOpacity(0.4),
                          ],
                        )
                      : LinearGradient(
                          colors: [
                            Color(0xFF6A11CB),
                            Color(0xFF2575FC),
                          ],
                        ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF6A11CB).withOpacity(0.5),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: chatProvider.isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Icon(Icons.send, color: Colors.white),
                  onPressed: chatProvider.isLoading ? null : _sendMessage,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}

// Main App
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatProvider(),
      child: MaterialApp(
        title: 'TripTalk - AI Travel Assistant',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.transparent,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
        home: const ChatScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
