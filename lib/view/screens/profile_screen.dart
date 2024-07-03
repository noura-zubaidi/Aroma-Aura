import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:perfumes_app/core/constants/colors.dart';
import 'package:perfumes_app/data/hive_helper.dart';
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
      print("Loading user data");
      final user = await AuthService.getUserInfoFromRealtimeDatabase();
      print("User data loaded: $user");
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

  void _showEditDialog() {
    final TextEditingController nameController =
        TextEditingController(text: _user?.name);
    final TextEditingController phoneController =
        TextEditingController(text: _user?.phoneNumber);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: log1,
          title: const Text(
            'Edit Info',
            style: TextStyle(
              fontFamily: 'LibreRegular',
              color: Colors.white,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(
                    fontFamily: 'LibreRegular',
                    color: Colors.white,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: phoneController,
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(
                    fontFamily: 'LibreRegular',
                    color: Colors.white,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedUser = UserModel(
                  uid: _user!.uid,
                  name: nameController.text,
                  phoneNumber: phoneController.text,
                  email: _user!.email,
                );

                await AuthService.updateUserRealTime(updatedUser);

                setState(() {
                  _user = updatedUser;
                });

                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
              child: Text(
                'Update',
                style: TextStyle(color: log1),
              ),
            ),
          ],
        );
      },
    );
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
                      GestureDetector(
                        onDoubleTap: _showEditDialog,
                        child: Text(
                          'Name: ${_user!.name}',
                          style: const TextStyle(
                            fontFamily: 'LibreBold',
                            fontSize: 17,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onDoubleTap: _showEditDialog,
                        child: Text(
                          'Phone Number: ${_user!.phoneNumber}',
                          style: const TextStyle(
                            fontFamily: 'LibreRegular',
                            fontSize: 15,
                            color: Colors.black,
                          ),
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
