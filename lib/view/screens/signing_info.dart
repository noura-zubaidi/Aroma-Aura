import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:perfumes_app/core/constants/colors.dart';
import 'package:perfumes_app/model/user_model.dart';
import 'package:perfumes_app/view/screens/home_screen.dart';
import 'package:perfumes_app/view_model/authentication.dart';

class SigningInfo extends StatefulWidget {
  SigningInfo({super.key});

  @override
  State<SigningInfo> createState() => _SigningInfoState();
}

class _SigningInfoState extends State<SigningInfo> {
  final GlobalKey<FormState> _formkey = GlobalKey();
  late TextEditingController _passwordController;
  late TextEditingController _phoneController;
  @override
  void initState() {
    super.initState();

    _passwordController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveUserInfo() async {
    if (_formkey.currentState!.validate()) {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        UserModel appUser = UserModel(
          uid: user.uid,
          phoneNumber: _phoneController.text,
          email: user.email,
        );
        await AuthService.saveUserToDatabase(
          user,
          phoneNumber: _phoneController.text,
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        print("No user is signed in.");
      }
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
                      'Complete Your Info',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'LibreRegular',
                        fontSize: 30,
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
                              labelText: 'Phone Number',
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
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: TextFormField(
                            cursorColor: Colors.white,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password Cannot Be Empty';
                              }
                              return null;
                            },
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'password',
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
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 200,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _saveUserInfo,
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            child: Text(
                              'Save Info',
                              style: TextStyle(
                                fontFamily: 'LibreRegular',
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                                color: log1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
                ],
              )),
        ),
      ),
    );
  }
}
