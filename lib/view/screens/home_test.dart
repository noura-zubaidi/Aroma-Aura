import 'package:flutter/material.dart';
import 'package:perfumes_app/view/screens/auth_test.dart';
import 'package:perfumes_app/view_model/authentication.dart';
import 'package:provider/provider.dart';

class HomeScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => AuthScreen()),
              );
            },
          ),
        ],
      ),
      body: const Center(child: Text('Welcome!')),
    );
  }
}
