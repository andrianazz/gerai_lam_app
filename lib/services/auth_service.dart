import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../theme.dart';

class AuthService {
  var auth = FirebaseAuth.instance;

  Future signIn(BuildContext context, String email, String password) async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 1000),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text(
                "Authenticating. Please wait .....",
                textAlign: TextAlign.center,
              ),
            ],
          ),
          backgroundColor: primaryColor,
        ),
      );
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Failed to Login!",
            textAlign: TextAlign.center,
          ),
          backgroundColor: redColor,
        ),
      );
      print(e);
    }
  }

  Future createAuth(
      BuildContext context, String email, String password, String name) async {
    try {
      User? u = auth.currentUser;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 1000),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text(
                "Authenticating. Please wait .....",
                textAlign: TextAlign.center,
              ),
            ],
          ),
          backgroundColor: primaryColor,
        ),
      );

      UserCredential userCred = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await userCred.user?.updateDisplayName(name);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Gagal Menambahkan Autentikasi!",
            textAlign: TextAlign.center,
          ),
          backgroundColor: redColor,
        ),
      );
      print(e);
    }
  }

  Future signOut() async {
    await auth.signOut();
  }
}
