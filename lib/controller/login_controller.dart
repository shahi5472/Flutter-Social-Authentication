import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_social_authentication/screen/home_view.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxString name = "".obs;
  RxString email = "".obs;

  Future<void> googleSignIn(context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

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
        Get.offAll(const HomeView());
      }
    } catch (e) {
      print("Error $e");
      showSnackBar(context, 'Error $e');
    }
  }

  Future<void> facebookSignIn(context) async {
    try {
      final LoginResult loginResult = await FacebookAuth.i.login();

      if (loginResult.status == LoginStatus.success) {
        final OAuthCredential credential =
            FacebookAuthProvider.credential(loginResult.accessToken!.token);
        await _handleSignInWithCredential(credential);
        showSnackBar(context, 'Sign in successful');
        Get.offAll(const HomeView());
      } else {
        showSnackBar(context, 'Something went to wrong try again');
      }
    } catch (e) {
      print("Error $e");
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
