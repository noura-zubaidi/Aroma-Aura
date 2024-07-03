import 'package:firebase_database/firebase_database.dart';
import 'package:perfumes_app/model/user_model.dart';

class UserService {
  final DatabaseReference _usersRef = FirebaseDatabase.instance.ref('users');

  Future<void> addUser(UserModel user) async {
    try {
      final userRef =
          _usersRef.child(user.uid!); // Reference to a specific item
      await userRef.set({
        'userId': user.uid,
        'username': user.name,
        //'image': item.image,
        'phoneNumber': user.name,
        'email': user.email,
      });
      print('User added: ${user.name}');
    } catch (e) {
      print('Error adding user: $e');
    }
  }

  Future<void> updateUserInfo(UserModel user) async {
    try {
      final userRef = _usersRef.child(user.uid!);
      await userRef.update({
        'userId': user.uid,
        //'image': item.image,
        'username': user.name,
        'phoneNumber': user.name,
        'email': user.email,
      });
      print('user updated: ${user.name}');
    } catch (e) {
      print('Error updating user: $e');
    }
  }
}
