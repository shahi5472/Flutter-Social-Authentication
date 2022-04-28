import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_authentication/controller/login_controller.dart';
import 'package:flutter_social_authentication/screen/home_view.dart';
import 'package:flutter_social_authentication/screen/login_view.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put<LoginController>(LoginController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Social Authentication',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
      FirebaseAuth.instance.currentUser == null
          ? const LoginView()
          : const HomeView(),
    );
  }
}
