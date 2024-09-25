import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import "package:cloud_firestore/cloud_firestore.dart";

class FirebaseHandler {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? user;

  Future<int> signIn() async {
    /**
     * returns 1 if user is already registered
     * returns 2 if user is not registered.
     * returns 0 if authentication failed.
     */
    try {
      _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      FirebaseAuth.instance.signInWithCredential(credential);
      user = googleUser;
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('google_id', isEqualTo: googleUser?.id)
          .get();
      user = googleUser;
      if (snapshot.docs.isNotEmpty) {
        return 1; // user is found
      } else {
        return 2; // user is not found
      }
    } on AssertionError {
      return 0;
    } on StateError {
      return 2;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }

  Future<bool> registerUser(
      String firstName, String lastName, String year) async {
    try {
      final GoogleSignInAccount? googleUser = _googleSignIn.currentUser;

      await _firestore.collection('users').add({
        'firstname': firstName,
        'lastname': lastName,
        'google_id': googleUser?.id,
        'email': googleUser?.email,
        'year': year,
      });
      user = googleUser;
      return true;
    } on Error {
      return false;
    }
  }
}
