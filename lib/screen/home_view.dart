import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_authentication/screen/login_view.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              FirebaseAuth.instance.currentUser?.displayName ?? 'Name Empty',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              FirebaseAuth.instance.currentUser?.email ?? 'Email Empty',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Get.offAll(const LoginView());
              },
              child: const Text('SignOut'),
            ),
          ],
        ),
      ),
    );
  }
}
