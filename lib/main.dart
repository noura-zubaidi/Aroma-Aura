import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/adapters.dart';
import 'package:perfumes_app/core/state_management/user_session.dart';
import 'package:perfumes_app/data/hive_helper.dart';
import 'package:perfumes_app/firebase_options.dart';
import 'package:perfumes_app/model/purchased_model.dart';
import 'package:perfumes_app/model/user_model.dart';

import 'package:perfumes_app/view/screens/home_screen.dart';

import 'package:perfumes_app/view/screens/welcome_screen.dart';

import 'package:perfumes_app/view_model/categories_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();

  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(PurchasedItemAdapter());
  await HiveHelper.init();
  await UserSessionManager.init();
  bool isLoggedIn = await UserSessionManager.isUserLoggedIn();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp({required this.isLoggedIn});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
      ],
      child: MaterialApp(
        home: isLoggedIn ? HomeScreen() : const WelcomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
