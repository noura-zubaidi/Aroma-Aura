import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:perfumes_app/firebase_options.dart';
import 'package:perfumes_app/repo/categories_service.dart';
import 'package:perfumes_app/view/screens/auth_test.dart';
import 'package:perfumes_app/view/screens/home_screen.dart';
import 'package:perfumes_app/view/screens/login_screen.dart';
import 'package:perfumes_app/view/screens/testinggggg.dart';
import 'package:perfumes_app/view/screens/welcome_screen.dart';
import 'package:perfumes_app/view_model/authentication.dart';
import 'package:perfumes_app/view_model/categories_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Dio dio = Dio();
    final CategoryService categoryService = CategoryService(dio);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CategoryProvider(categoryService),
        ),
      ],
      child: MaterialApp(
        home: HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
