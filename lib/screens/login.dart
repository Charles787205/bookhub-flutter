import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'home.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              final GoogleSignInAccount? googleUser =
                  await GoogleSignIn().signIn();
              final GoogleSignInAuthentication? googleAuth =
                  await googleUser?.authentication;
              final credential = GoogleAuthProvider.credential(
                accessToken: googleAuth?.accessToken,
                idToken: googleAuth?.idToken,
              );
              FirebaseAuth.instance.signInWithCredential(credential);
            } on FirebaseAuthException catch (e) {
              print("Errrorrrrr");
            }
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}
