import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              child: Image.asset(
                'images/chat-screen.png',
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: Image.asset(
                'images/spinner.gif',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              child: const Text("SIGN OUT"),
            ),
          ],
        ),
      ),
    );
  }
}
