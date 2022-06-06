import 'package:country_code_picker/country_code.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:flutter_social_authentication/screen/home_view.dart';
import 'package:flutter_social_authentication/screen/otp_view.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginController extends GetxController {
  BuildContext? context;

  final formKey = GlobalKey<FormState>();
  final otpFormKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final phoneEditController = TextEditingController();

  final otpEditController = TextEditingController();

  final emailEditController = TextEditingController();
  final passwordEditController = TextEditingController();

  Rx<CountryCode> selectedCode = CountryCode().obs;

  RxString verificationId = ''.obs;

  RxString authType = "phone".obs;

  void phoneEmailType(String type) {
    authType.value = type;
  }

  Future<void> emailPasswordSignIn() async {
    if (!formKey.currentState!.validate()) return;

    formKey.currentState!.save();
  }

  Future<void> phoneSingIn(context) async {
    this.context = context;

    if (!formKey.currentState!.validate()) return;

    formKey.currentState!.save();

    String phoneNumber =
        '${selectedCode.value.dialCode}${phoneEditController.text.trim()}';

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<void> otpVerify() async {
    if (!formKey.currentState!.validate()) return;

    formKey.currentState!.save();

    try {
      AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otpEditController.text.trim(),
      );
      await _handleSignInWithCredential(credential);
      showSnackBar(context, 'Sign in successful');
      Get.offAll(const HomeView());
    } on FirebaseAuthException catch (_) {
      showSnackBar(context, 'Invalid OTP');
    } catch (e) {
      showSnackBar(context, 'Exception $e');
    }
  }

  Future<void> verificationCompleted(AuthCredential credential) async {
    await _handleSignInWithCredential(credential);
    showSnackBar(context, 'Sign in successful');
    Get.offAll(const HomeView());
  }

  Future<void> verificationFailed(exception) async {
    showSnackBar(Get.context, 'Exception => $exception');
  }

  Future<void> codeSent(String verifyId, int? forceResendingToken) async {
    verificationId(verifyId);
    Get.to(const OTPView());
  }

  Future<void> codeAutoRetrievalTimeout(String verificationId) async {}

  ///Google Sign in method start
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
      showSnackBar(context, 'Error $e');
    }
  }

  ///Google Sign in method end

  /// Facebook sign in method start
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
      showSnackBar(context, 'Error $e');
    }
  }

  /// Facebook sign in method end

  ///Apple sign in method start
  Future<void> appleSignIn(context) async {
    try {
      final appleIDCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final OAuthProvider oAuthProvider = OAuthProvider('apple.com');

      final credential = oAuthProvider.credential(
        idToken: appleIDCredential.identityToken,
        accessToken: appleIDCredential.authorizationCode,
      );

      await _handleSignInWithCredential(credential);
      showSnackBar(context, 'Sign in successful');
      Get.offAll(const HomeView());
    } catch (e) {
      showSnackBar(context, 'Error $e');
    }
  }

  ///Apple sign in method end

  Future<void> _handleSignInWithCredential(credential) async {
    UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    debugPrint('_handleSignInWithCredential ${userCredential.user}');
    if (userCredential.user != null) {}
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
