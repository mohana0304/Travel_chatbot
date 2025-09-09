// import 'package:flutter/material.dart';

// void main() {
//   runApp(TravelChatbotApp());
// }

// class TravelChatbotApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Travel AI Chatbot',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: SignUpPage(), // Start with SignUpPage
//     );
//   }
// }

// // Simulated in-memory storage for credentials (for demo purposes)
// List<Map<String, String>> _userCredentials = [];

// class SignUpPage extends StatefulWidget {
//   @override
//   _SignUpPageState createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   void _signUp() {
//     String email = _emailController.text.trim();
//     String password = _passwordController.text.trim();

//     if (email.isNotEmpty && password.isNotEmpty) {
//       // Store credentials in memory (simulated sign-up)
//       _userCredentials.add({'email': email, 'password': password});
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => ChatbotHomePage()),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please enter email and password')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Travel AI Chatbot Sign Up')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(
//                 labelText: 'Email',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(
//                 labelText: 'Password',
//                 border: OutlineInputBorder(),
//               ),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _signUp,
//               child: Text('Sign Up'),
//             ),
//             SizedBox(height: 10),
//             TextButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => LoginPage()),
//                 );
//               },
//               child: Text('Already have an account? Log in'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   void _login() {
//     String email = _emailController.text.trim();
//     String password = _passwordController.text.trim();

//     // Simulate login by checking in-memory credentials
//     bool isValid = _userCredentials.any(
//       (cred) => cred['email'] == email && cred['password'] == password,
//     );

//     if (isValid) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => ChatbotHomePage()),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Invalid email or password')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Travel AI Chatbot Login')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(
//                 labelText: 'Email',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(
//                 labelText: 'Password',
//                 border: OutlineInputBorder(),
//               ),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _login,
//               child: Text('Login'),
//             ),
//             SizedBox(height: 10),
//             TextButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => SignUpPage()),
//                 );
//               },
//               child: Text('Don’t have an account? Sign up'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ChatbotHomePage extends StatefulWidget {
//   @override
//   _ChatbotHomePageState createState() => _ChatbotHomePageState();
// }

// class _ChatbotHomePageState extends State<ChatbotHomePage> {
//   final _cityController = TextEditingController();
//   String _response = '';

//   void _getTravelInfo() {
//     String city = _cityController.text.trim().toLowerCase();
//     if (city.isEmpty) {
//       setState(() {
//         _response = 'Please enter a city or country name! 😊';
//       });
//       return;
//     }

//     // Simulate AI response for Delhi
//     if (city == 'delhi') {
//       setState(() {
//         _response = '''
// 🌟 **Hello, traveler! Welcome to vibrant Delhi!** 🌟
// I'm thrilled to share some amazing recommendations for your trip to India's capital. Here's your personalized guide:

// 🌆 **Top Places to Visit**
// - **Red Fort**: A stunning Mughal fortress with intricate architecture and historical significance.
// - **India Gate**: An iconic war memorial, perfect for an evening stroll.
// - **Qutub Minar**: A UNESCO World Heritage Site and the tallest brick minaret in the world.
// - **Lotus Temple**: A serene Bahá’í temple shaped like a lotus flower, open to all faiths.
// - **Chandni Chowk**: A bustling market with hidden gems, perfect for exploring Old Delhi.

// 🏨 **Best Hostels & Hotels**
// - **Budget: Zostel Delhi** - A vibrant hostel with a social vibe, located in Paharganj.
// - **Budget: Moustache Hostel** - Affordable and cozy, great for backpackers.
// - **Mid-range: Bloomrooms @ New Delhi Railway Station** - Modern, clean, and centrally located.
// - **Luxury: The Oberoi, New Delhi** - A 5-star hotel with impeccable service and stunning views.
// - **Luxury: Taj Mahal Hotel** - A luxurious stay with a blend of tradition and elegance.

// 🍲 **Restaurants & Street Food Recommendations**
// - **Karim’s** (Old Delhi): Famous for mouthwatering Mughlai dishes like mutton korma and kebabs.
// - **Paranthe Wali Gali** (Chandni Chowk): Try stuffed parathas with unique fillings like rabri or paneer.
// - **Haldiram’s** (Connaught Place): Perfect for chaat, dosas, and other Indian snacks.
// - **Dilli Haat**: A cultural market with food stalls offering regional delicacies from across India.

// 🥘 **Must-Try Foods**
// - **Chole Bhature**: Spicy chickpeas with fluffy fried bread, a Delhi classic.
// - **Butter Chicken**: Creamy, rich, and packed with flavor – a Mughlai delight.
// - **Aloo Tikki**: Crispy potato patties served with tangy chutneys.
// - **Golgappa (Pani Puri)**: Bursting with spicy and tangy water, a street food favorite.
// - **Kulfi**: A creamy, frozen dessert to cool you down after spicy treats.

// 🚇 **Travel Tips**
// - **Best Season to Visit**: October to March for pleasant weather, avoiding the summer heat.
// - **Safety Tips**: Stay cautious in crowded areas like markets; keep valuables secure.
// - **Local Transport**: Use the Delhi Metro for affordable, efficient travel across the city.
// - **Cultural Etiquette**: Dress modestly at religious sites and remove shoes where required.
// - **Pro Tip**: Bargain politely at markets like Chandni Chowk for the best deals!

// Enjoy your adventure in Delhi! Let me know if you'd like tips for another destination! 🌍
//         ''';
//       });
//     } else {
//       setState(() {
//         _response =
//             "Sorry, I don't have info for '$city' yet! 😅 Try 'Delhi' or another major city, or let me know how I can help!";
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Travel AI Chatbot')),
//       body: Column(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(16.0),
//             child: TextField(
//               controller: _cityController,
//               decoration: InputDecoration(
//                 labelText: 'Enter city or country (e.g., Delhi)',
//                 border: OutlineInputBorder(),
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: _getTravelInfo,
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: SingleChildScrollView(
//               padding: EdgeInsets.all(16.0),
//               child: Text(
//                 _response,
//                 style: TextStyle(fontSize: 16),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

void main() {
  // Catch and log unhandled errors
  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint('Flutter Error: ${details.exceptionAsString()}');
    debugPrint(details.stack.toString());
  };

  runApp(TravelChatbotApp());
}

class TravelChatbotApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel AI Chatbot',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurple,
        colorScheme: ColorScheme.dark(
          primary: Colors.deepPurple,
          secondary: Colors.purpleAccent, // Replaced accentColor
        ),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.deepPurple[900],
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purpleAccent),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purpleAccent, width: 2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purpleAccent,
            foregroundColor: Colors.black,
          ),
        ),
      ),
      initialRoute: '/signup',
      routes: {
        '/signup': (context) => SignUpPage(),
        '/login': (context) => LoginPage(),
        '/chatbot': (context) => ChatbotHomePage(),
      },
    );
  }
}

// Simulated in-memory storage for credentials (for demo purposes)
List<Map<String, String>> _userCredentials = [];

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _signUp() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }

    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid email')),
      );
      return;
    }

    // Store credentials
    _userCredentials.add({'email': email, 'password': password});
    debugPrint('Signed up: $email');
    Navigator.pushReplacementNamed(context, '/chatbot');
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple[900]!, Colors.black],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Create Your Account 🌍',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.purpleAccent),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signUp,
                child: Text('Sign Up'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text('Already have an account? Log in',
                    style: TextStyle(color: Colors.purpleAccent)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }

    bool isValid = _userCredentials.any(
      (cred) => cred['email'] == email && cred['password'] == password,
    );

    if (isValid) {
      debugPrint('Logged in: $email');
      Navigator.pushReplacementNamed(context, '/chatbot');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple[900]!, Colors.black],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome Back! 🌟',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.purpleAccent),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: Text('Don’t have an account? Sign up',
                    style: TextStyle(color: Colors.purpleAccent)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Message {
  final String text;
  final bool isUser;

  Message({required this.text, required this.isUser});
}

class ChatbotHomePage extends StatefulWidget {
  @override
  _ChatbotHomePageState createState() => _ChatbotHomePageState();
}

class _ChatbotHomePageState extends State<ChatbotHomePage> {
  final _cityController = TextEditingController();
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _addBotMessage('Hello! Enter a city or country to get travel tips! 🌍');
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(Message(text: text, isUser: false));
    });
    _scrollToBottom();
  }

  void _addUserMessage(String text) {
    setState(() {
      _messages.add(Message(text: text, isUser: true));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _getTravelInfo() {
    String city = _cityController.text.trim();
    if (city.isEmpty) {
      _addBotMessage('Please enter a city or country name! 😊');
      return;
    }

    _addUserMessage(city);
    _cityController.clear();

    // Simulate AI response for Delhi
    if (city.toLowerCase() == 'delhi') {
      _addBotMessage('''
🌟 **Hello, traveler! Welcome to vibrant Delhi!** 🌟  
I'm thrilled to share some amazing recommendations for your trip to India's capital. Here's your personalized guide:

🌆 **Top Places to Visit**  
- **Red Fort**: A stunning Mughal fortress with intricate architecture and historical significance.  
- **India Gate**: An iconic war memorial, perfect for an evening stroll.  
- **Qutub Minar**: A UNESCO World Heritage Site and the tallest brick minaret in the world.  
- **Lotus Temple**: A serene Bahá’í temple shaped like a lotus flower, open to all faiths.  
- **Chandni Chowk**: A bustling market with hidden gems, perfect for exploring Old Delhi.

🏨 **Best Hostels & Hotels**  
- **Budget: Zostel Delhi** - A vibrant hostel with a social vibe, located in Paharganj.  
- **Budget: Moustache Hostel** - Affordable and cozy, great for backpackers.  
- **Mid-range: Bloomrooms @ New Delhi Railway Station** - Modern, clean, and centrally located.  
- **Luxury: The Oberoi, New Delhi** - A 5-star hotel with impeccable service and stunning views.  
- **Luxury: Taj Mahal Hotel** - A luxurious stay with a blend of tradition and elegance.

🍲 **Restaurants & Street Food Recommendations**  
- **Karim’s** (Old Delhi): Famous for mouthwatering Mughlai dishes like mutton korma and kebabs.  
- **Paranthe Wali Gali** (Chandni Chowk): Try stuffed parathas with unique fillings like rabri or paneer.  
- **Haldiram’s** (Connaught Place): Perfect for chaat, dosas, and other Indian snacks.  
- **Dilli Haat**: A cultural market with food stalls offering regional delicacies from across India.  

🥘 **Must-Try Foods**  
- **Chole Bhature**: Spicy chickpeas with fluffy fried bread, a Delhi classic.  
- **Butter Chicken**: Creamy, rich, and packed with flavor – a Mughlai delight.  
- **Aloo Tikki**: Crispy potato patties served with tangy chutneys.  
- **Golgappa (Pani Puri)**: Bursting with spicy and tangy water, a street food favorite.  
- **Kulfi**: A creamy, frozen dessert to cool you down after spicy treats.

🚇 **Travel Tips**  
- **Best Season to Visit**: October to March for pleasant weather, avoiding the summer heat.  
- **Safety Tips**: Stay cautious in crowded areas like markets; keep valuables secure.  
- **Local Transport**: Use the Delhi Metro for affordable, efficient travel across the city.  
- **Cultural Etiquette**: Dress modestly at religious sites and remove shoes where required.  
- **Pro Tip**: Bargain politely at markets like Chandni Chowk for the best deals!

Enjoy your adventure in Delhi! Let me know if you'd like tips for another destination! 🌍
      ''');
    } else {
      _addBotMessage(
          "Sorry, I don't have info for '$city' yet! 😅 Try 'Delhi' or another major city, or let me know how I can help!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Travel AI Chatbot',
            style: TextStyle(color: Colors.purpleAccent)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple[900]!, Colors.black],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.all(16.0),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Align(
                    alignment: message.isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      margin: EdgeInsets.symmetric(vertical: 4.0),
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: message.isUser
                            ? Colors.purpleAccent.withOpacity(0.8)
                            : Colors.grey[800],
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        message.text,
                        style: TextStyle(
                            color:
                                message.isUser ? Colors.black : Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        labelText: 'Enter city or country (e.g., Delhi)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.send, color: Colors.purpleAccent),
                          onPressed: _getTravelInfo,
                        ),
                      ),
                      onSubmitted: (_) => _getTravelInfo(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
