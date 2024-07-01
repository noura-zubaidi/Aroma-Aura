import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String? uid;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? phoneNumber;

  @HiveField(3)
  String? email;

  UserModel({this.uid, this.name, this.phoneNumber, this.email});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
    );
  }
}
