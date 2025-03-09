import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'home_page.dart'; // Add this import

class LoginRegisterPage extends StatefulWidget {
  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  bool isLogin = true;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String errorMessage = ''; // Add this line

  void toggleFormMode() {
    setState(() {
      isLogin = !isLogin;
      errorMessage = ''; // Reset error message when toggling form
    });
  }

  void handleAuth() async {
    try {
      if (isLogin) {
        // Login logic
        UserCredential user = await _auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        print("User logged in: ${user.user?.email}");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()), // Navigate to HomePage
        );
      } else {
        // Register logic
        UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        print("User registered: ${user.user?.email}");
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = (e is FirebaseAuthException) ? e.message ?? 'An error occurred' : 'An error occurred'; // Update error message
        });
      }
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? 'Login' : 'Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            if (errorMessage.isNotEmpty) // Display error message if not empty
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleAuth,
              child: Text(isLogin ? 'Login' : 'Register'),
            ),
            TextButton(
              onPressed: toggleFormMode,
              child: Text(isLogin
                  ? 'Don\'t have an account? Register'
                  : 'Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
