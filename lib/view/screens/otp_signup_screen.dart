import 'package:flutter/material.dart';
import 'package:perfumes_app/core/constants/colors.dart';
import 'package:perfumes_app/view/screens/home_screen.dart';
import 'package:perfumes_app/view/screens/signing_info.dart';
import 'package:perfumes_app/view_model/authentication.dart';

class OtpSignupScreen extends StatefulWidget {
  final String phone;

  OtpSignupScreen({required this.phone});

  @override
  _OtpSignupScreenState createState() => _OtpSignupScreenState();
}

class _OtpSignupScreenState extends State<OtpSignupScreen> {
  bool _isLoading = false;
  TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _verifyOtp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await AuthService.loginWithOtp(otp: _otpController.text);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SigningInfo()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: log1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Enter OTP',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'LibreRegular',
                    fontSize: 30,
                    fontWeight: FontWeight.w700)),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 90),
              child: TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: 'OTP',
                      labelStyle: TextStyle(
                          fontFamily: 'LibreRegular',
                          fontSize: 14,
                          color: Colors.white),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1)))),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Colors.white,
                  ))
                : ElevatedButton(
                    onPressed: _verifyOtp,
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        backgroundColor: Colors.white,
                        fixedSize: const Size(200, 55)),
                    child: Text(
                      'Verify OTP',
                      style: TextStyle(
                          fontFamily: 'LibreRegular',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: log1),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
