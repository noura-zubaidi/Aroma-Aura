import 'package:flutter/material.dart';
import 'package:perfumes_app/view/screens/home_screen.dart';
import 'package:perfumes_app/view/screens/login_screen.dart';
import 'package:perfumes_app/view/screens/otp_screen.dart';
import 'package:perfumes_app/view/screens/signup_screen.dart';
import 'package:perfumes_app/view_model/authentication.dart';

void signInWithGoogle(BuildContext context) async {
  await AuthService.signInWithGoogle();
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (context) => HomeScreen()),
  );
}

void sendOtp({
  required BuildContext context,
  required TextEditingController phoneController,
  required GlobalKey<FormState> formKey,
}) async {
  if (formKey.currentState!.validate()) {
    AuthService.sentOtp(
      phone: phoneController.text,
      errorStep: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send OTP')),
        );
      },
      nextStep: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(phone: phoneController.text),
          ),
        );
      },
    );
  }
}

void logout(BuildContext context) async {
  await AuthService.logout();
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => LoginScreen()),
  );
}

void navigateToSignupScreen({
  required BuildContext context,
  required TextEditingController phoneController,
}) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => SignupScreen(phone: phoneController.text),
    ),
  );
}
