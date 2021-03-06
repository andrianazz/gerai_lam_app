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

  Future<UserCredential> register(
      context, String email, String password) async {
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
        .createUserWithEmailAndPassword(email: email, password: password);

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

    await app.delete();
    return Future.sync(() => userCredential);
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

  Future updatePassword(BuildContext context, String pass) async {
    await auth.currentUser!.updatePassword(pass);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 1000),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text(
              "Mengubah Password. Mohon Tunggu .....",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        backgroundColor: primaryColor,
      ),
    );
  }

  Future updatePasswordwithEmail(BuildContext context, String email) async {
    await auth.sendPasswordResetEmail(email: email);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 1000),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text(
              "Mengirimkan. Silahkan Cek Email terkait .....",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        backgroundColor: primaryColor,
      ),
    );
  }

  Future signOut() async {
    await auth.signOut();
  }
}
