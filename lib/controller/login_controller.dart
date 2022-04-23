import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _googleSingIn = GoogleSignIn();

  RxString name = "".obs;
  RxString email = "".obs;

  Future<void> googleSignIn(context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSingIn.signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth == null) {
        showSnackBar(context, 'Google sign in authentication error');
      } else {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await _handleSignInWithCredential(credential);
        showSnackBar(context, 'Sign in successful');
      }
    } catch (e) {
      showSnackBar(context, 'Error $e');
    }
  }

  Future<void> _handleSignInWithCredential(credential) async {
    UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    if (userCredential.user != null) {
      name.value = userCredential.user!.displayName!;
      email.value = userCredential.user!.email!;
    }
  }

  void showSnackBar(context, content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.black,
        content: Text(
          content,
          style: const TextStyle(color: Colors.white, letterSpacing: 0.5),
        ),
      ),
    );
  }
}
