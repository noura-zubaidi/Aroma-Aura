import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:perfumes_app/core/constants/colors.dart';
import 'package:perfumes_app/model/user_model.dart';
import 'package:perfumes_app/view/screens/home_screen.dart';
import 'package:perfumes_app/view_model/authentication.dart';

class SigningInfo extends StatefulWidget {
  final String? phone;
  final String? email;
  final bool isGoogleSignUp;

  SigningInfo({this.phone, required this.isGoogleSignUp, this.email});

  @override
  State<SigningInfo> createState() => _SigningInfoState();
}

class _SigningInfoState extends State<SigningInfo> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveUserInfo() async {
    if (_formkey.currentState!.validate()) {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        UserModel appUser = UserModel(
          uid: user.uid,
          name: widget.isGoogleSignUp ? user.displayName : _nameController.text,
          email: _emailController.text,
          phoneNumber:
              widget.isGoogleSignUp ? _phoneController.text : widget.phone,
        );

        await AuthService.saveUserToDatabase(
          user,
          name: widget.isGoogleSignUp ? user.displayName : _nameController.text,
          phoneNumber:
              widget.isGoogleSignUp ? _phoneController.text : widget.phone,
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
      backgroundColor: log1,
      body: Padding(
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
                      if (!widget.isGoogleSignUp) ...[
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: TextFormField(
                            controller: _nameController,
                            cursorColor: Colors.white,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Name Cannot Be Empty';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Name',
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
                            controller: _emailController,
                            cursorColor: Colors.white,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email Cannot Be Empty';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Email',
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
                      ],
                      if (widget.isGoogleSignUp) ...[
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: TextFormField(
                            controller: _phoneController,
                            cursorColor: Colors.white,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Phone Number Cannot Be Empty';
                              }
                              return null;
                            },
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
                            controller: _nameController,
                            cursorColor: Colors.white,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Name Cannot Be Empty';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Name',
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
                      ],
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveUserInfo,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: Text(
                            'Save Info',
                            style: TextStyle(
                              fontFamily: 'LibreRegular',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: log1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
