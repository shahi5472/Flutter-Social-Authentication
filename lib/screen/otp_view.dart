import 'package:flutter/material.dart';
import 'package:flutter_social_authentication/controller/login_controller.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OTPView extends GetView<LoginController> {
  const OTPView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.5),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Form(
          key: controller.otpFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Pinput(
                length: 6,
                controller: controller.otpEditController,
                validator: (String? s) {
                  if (s == null || s.length != 6) return 'Wrong OTP';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => controller.otpVerify(),
                child: const Text('Verify'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
