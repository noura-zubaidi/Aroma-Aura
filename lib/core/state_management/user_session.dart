import 'package:firebase_database/firebase_database.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:perfumes_app/data/hive_helper.dart';
import 'package:perfumes_app/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSessionManager {
  static late Box<UserModel> _userBox;

  static Future<void> init() async {
    _userBox = HiveHelper.userBox;

    // Initialize SharedPreferences
    await SharedPreferences.getInstance();
  }

  // Save the user session in SharedPreferences
  static Future<void> saveUserSession(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_uid', uid);

    // Optionally save the user info to Hive
    final user = HiveHelper.getUser(uid);
    if (user != null) {
      await HiveHelper.addUser(user);
    }
  }

  // Clear the user session in SharedPreferences
  static Future<void> clearUserSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_uid');

    // Optionally clear the user data from Hive
    final user = _userBox.get(_userBox.keys.first.toString());
    if (user != null) {
      await HiveHelper.removeUser(user.uid!);
    }
  }

  // Check if a user is logged in
  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_uid') != null;
  }

  // Get the current user's UID from SharedPreferences
  static Future<String?> getUserUid() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_uid');
  }

  // Get the current user from Hive
  static Future<UserModel?> getUser() async {
    final uid = await getUserUid();
    if (uid != null) {
      DatabaseReference databaseReference =
          FirebaseDatabase.instance.ref().child("users").child("users/$uid");
      final DatabaseEvent event = await databaseReference.once();
      final DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        Map<String, dynamic> userData =
            Map<String, dynamic>.from(snapshot.value as Map);
        return UserModel.fromMap(userData);
      }
    }
    return null;
  }
}
