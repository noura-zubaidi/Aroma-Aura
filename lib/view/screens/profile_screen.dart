import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:perfumes_app/core/constants/colors.dart';
import 'package:perfumes_app/model/user_model.dart';
import 'package:perfumes_app/view_model/authentication.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    try {
      final user = await AuthService.getUserInfo();
      setState(() {
        _user = user;
        _loading = false;
      });
    } catch (e) {
      print("Error loading user data: $e");
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'LibreRegular',
          ),
        ),
        backgroundColor: log1,
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
              color: log1,
            ))
          : _user == null
              ? const Center(child: Text('No user data available'))
              : Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Name: ${_user!.name}',
                        style: const TextStyle(
                          fontFamily: 'LibreBold',
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Phone Number: ${_user!.phoneNumber}',
                        style: const TextStyle(
                          fontFamily: 'LibreRegular',
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Email: ${_user!.email}',
                        style: const TextStyle(
                          fontFamily: 'LibreRegular',
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
