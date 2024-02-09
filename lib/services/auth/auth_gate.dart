import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:imessage/Pages/home_page.dart';
import 'package:imessage/services/auth/login_or_register.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user is loggeed id
          if(snapshot.hasData) {
            return const HomePage();
          }

          //user id not logged in
          else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}