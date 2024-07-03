import 'package:flutter/material.dart';
import 'package:perfumes_app/core/constants/colors.dart';

import 'package:perfumes_app/view/screens/signing_info.dart';
import 'package:perfumes_app/view_model/authentication.dart';

class OtpScreen extends StatefulWidget {
  final String phone;

  OtpScreen({required this.phone});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
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
        MaterialPageRoute(
          builder: (context) => SigningInfo(
            phone: widget.phone,
            isGoogleSignUp: false,
          ),
        ),
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
            const SizedBox(height: 20),
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
                      borderSide: BorderSide(color: Colors.white, width: 1)),
                ),
              ),
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
                        backgroundColor: Colors.white),
                    child: Text(
                      'Verify OTP',
                      style: TextStyle(
                        fontFamily: 'LibreRegular',
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        color: log1,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
