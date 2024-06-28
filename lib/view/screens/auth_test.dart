import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:perfumes_app/view/screens/home_test.dart';
import 'package:perfumes_app/view_model/authentication.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  String? _verificationId;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Phone Authentication')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            ElevatedButton(
              onPressed: () async {
                await authService.verifyPhoneNumber(
                  _phoneController.text,
                  (PhoneAuthCredential credential) async {
                    await authService.signInWithPhoneAuthCredential(credential);
                    if (authService.getCurrentUser() != null) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomeScreen2()),
                      );
                    }
                  },
                  (FirebaseAuthException e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Verification failed: ${e.message}')),
                    );
                  },
                  (String verificationId, int? resendToken) {
                    setState(() {
                      _verificationId = verificationId;
                    });
                  },
                  (String verificationId) {
                    setState(() {
                      _verificationId = verificationId;
                    });
                  },
                );
              },
              child: Text('Verify Phone Number'),
            ),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(labelText: 'Verification Code'),
            ),
            ElevatedButton(
              onPressed: () async {
                final phoneAuthCredential = PhoneAuthProvider.credential(
                  verificationId: _verificationId!,
                  smsCode: _codeController.text,
                );

                await authService
                    .signInWithPhoneAuthCredential(phoneAuthCredential);
                if (authService.getCurrentUser() != null) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomeScreen2()),
                  );
                }
              },
              child: Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }
}
