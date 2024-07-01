import 'package:flutter/material.dart';
import 'package:perfumes_app/core/constants/colors.dart';
import 'package:perfumes_app/view/screens/login_screen.dart';
import 'package:perfumes_app/view/screens/otp_screen.dart';
import 'package:perfumes_app/view/screens/signing_info.dart';
import 'package:perfumes_app/view_model/authentication.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey();
  late TextEditingController _phoneController;
  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _signUpWithGoogle() async {
    await AuthService.signUpWithGoogle();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SigningInfo()));
  }

  void _sendOtp() async {
    if (_formkey.currentState!.validate()) {
      AuthService.sentOtp(
        phone: _phoneController.text,
        errorStep: () {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Failed to send OTP')));
        },
        nextStep: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpScreen(phone: _phoneController.text),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: log1,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 60, left: 15),
                  child: Text(
                    'Welcome to Aroma Aura',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'LibreRegular',
                      fontSize: 33,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Phone Number Cannot Be Empty';
                              }
                              return null;
                            },
                            controller: _phoneController,
                            decoration: const InputDecoration(
                              labelText: 'Your Phone Number',
                              labelStyle: TextStyle(
                                fontFamily: 'LibreRegular',
                                fontSize: 14,
                                color: Colors.white,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 7),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _sendOtp,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                backgroundColor: Colors.white,
                              ),
                              child: Text(
                                'Send OTP',
                                style: TextStyle(
                                  fontFamily: 'LibreRegular',
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600,
                                  color: log1,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            },
                            child: const Text(
                              'Already Have An Account? Sign Up',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'LibreRegular',
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      child: Divider(
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Or sign in with',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontFamily: 'LibreRegular',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: Divider(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          fixedSize: const Size(40, 40),
                          padding: EdgeInsets.zero,
                          shape: const CircleBorder(),
                        ),
                        onPressed: _signUpWithGoogle,
                        child: Image.network(
                          "https://i.pinimg.com/originals/39/21/6d/39216d73519bca962bd4a01f3e8f4a4b.png",
                          width: 30,
                          height: 30,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
