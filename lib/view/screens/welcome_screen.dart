import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:perfumes_app/view/screens/signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta! < -5) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignupScreen()),
          );
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/welcome.png.png',
            fit: BoxFit.cover,
          ),
          Positioned.fill(
              child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1),
              child: Container(
                color: Colors.black.withOpacity(0.2),
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(bottom: 50),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'AROMA  AURA',
                      style: TextStyle(
                        fontSize: 32,
                        fontFamily: 'LibreRegular',
                        color: Color.fromARGB(153, 243, 222, 222),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ))
        ],
      ),
    ));
  }
}
