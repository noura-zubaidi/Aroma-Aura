import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:perfumes_app/firebase_options.dart';
import 'package:perfumes_app/repo/categories_service.dart';

import 'package:perfumes_app/view/screens/home_screen.dart';
import 'package:perfumes_app/view/screens/login_screen.dart';

import 'package:perfumes_app/view/screens/welcome_screen.dart';
import 'package:perfumes_app/view_model/authentication.dart';
import 'package:perfumes_app/view_model/categories_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ],
      child: MaterialApp(
        home: HomeScreen(),
      ),
    );
  }
}
