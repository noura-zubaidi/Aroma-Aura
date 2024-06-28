import 'package:flutter/material.dart';
import 'package:perfumes_app/core/constants/colors.dart';
import 'package:perfumes_app/view_model/authentication.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _formkey = GlobalKey();
  late TextEditingController _phoneController;
  late TextEditingController _otpController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _otpController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: log1,
        child: Padding(
          padding: const EdgeInsets.only(left: 15, top: 40),
          child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 70, left: 15),
                    child: Text('Welcome Back',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'LibreRegular',
                            fontSize: 35,
                            fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
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
                                  return 'Email Cannot Be Empty';
                                }
                                return null;
                              },
                              controller: _phoneController,
                              decoration: const InputDecoration(
                                  labelText: 'Your Email',
                                  labelStyle: TextStyle(
                                      fontFamily: 'LibreRegular',
                                      fontSize: 14,
                                      color: Colors.white),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 1))),
                            )),
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
                            controller: _otpController,
                            obscureText: true,
                            decoration: const InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                    fontFamily: 'LibreRegular',
                                    fontSize: 14,
                                    color: Colors.white),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 1))),
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              backgroundColor: Colors.white,
                              fixedSize: const Size(220, 55)),
                          child: Text(
                            'Send OTP',
                            style: TextStyle(
                                fontFamily: 'LibreRegular',
                                fontSize: 21,
                                fontWeight: FontWeight.w600,
                                color: log1),
                          ),
                        ),
                        const SizedBox(height: 50),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: InkWell(
                            onTap: () {},
                            child: const Text('Don\'t Have An Account? Sign Up',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'LibreRegular',
                                    fontSize: 18)),
                          ),
                        ),
                        const SizedBox(height: 170),
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
                              padding: EdgeInsets.all(16),
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
                                )),
                          ],
                        ),
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
                                onPressed: () {},
                                child: Image.network(
                                  "https://i.pinimg.com/originals/39/21/6d/39216d73519bca962bd4a01f3e8f4a4b.png",
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 1),
                            ClipOval(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  fixedSize: const Size(40, 40),
                                  padding: EdgeInsets.zero,
                                  shape: const CircleBorder(),
                                ),
                                onPressed: () {},
                                child: Image.network(
                                  "https://i.pinimg.com/originals/c1/45/7e/c1457ec61545d41c3398072daf3cbd53.png",
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 1),
                            ClipOval(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  fixedSize: const Size(40, 40),
                                  padding: EdgeInsets.zero,
                                  shape: const CircleBorder(),
                                ),
                                onPressed: () {},
                                child: Image.network(
                                  "https://qph.cf2.quoracdn.net/main-qimg-874b3e5fe6a58285fb9c52f108cf7bc5",
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
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
