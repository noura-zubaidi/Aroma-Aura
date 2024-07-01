import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:perfumes_app/model/purchased_model.dart';
import 'package:perfumes_app/model/user_model.dart';

class HiveHelper {
  static Future<void> init() async {
    await Hive.initFlutter();

    await Future.wait([
      Hive.openBox<UserModel>('userBox'),
      Hive.openBox<PurchasedItem>('cartBox'),
    ]);
  }

  static Box<UserModel> get userBox => Hive.box<UserModel>('userBox');

  static Box<PurchasedItem> get cartBox => Hive.box<PurchasedItem>('cartBox');

  static Future<void> addUser(UserModel user) async {
    await userBox.put(user.uid, user);
  }

  static UserModel? getUser(String uid) {
    return userBox.get(uid);
  }

  static Future<void> removeUser(String uid) async {
    await userBox.delete(uid);
  }

  static Future<void> addPurchasedItem(PurchasedItem item) async {
    await cartBox.put(item.itemId, item);
  }

  static PurchasedItem? getPurchasedItem(String id) {
    return cartBox.get(id);
  }

  static Future<void> removePurchasedItem(String id) async {
    await cartBox.delete(id);
  }

  static Future<void> clearUserBox() async {
    await userBox.clear();
  }

  static Future<void> clearCartBox() async {
    await cartBox.clear();
  }
}
