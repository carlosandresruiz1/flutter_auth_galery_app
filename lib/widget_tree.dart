import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Pages/home_page.dart';
import 'Pages/login_resgister_page.dart';

class WidgetTree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasData) {
              return HomePage();
            } else {
              return LoginRegisterPage();
            }
          },
        ),
        '/login': (context) => LoginRegisterPage(), // Add this route
      },
    );
  }
}
