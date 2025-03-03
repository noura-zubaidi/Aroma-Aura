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

  static Future<void> removePurchasedItem(String itemId) async {
    final box = Hive.box<PurchasedItem>('cartBox');
    final item = box.values.firstWhere((element) => element.itemId == itemId);
    await item.delete();
  }

  static Future<void> clearUserBox() async {
    await userBox.clear();
  }

  static Future<void> updateUser(UserModel user) async {
    final box = await Hive.openBox<UserModel>('userBox');
    await box.put(user.uid, user);
    print("User data updated in Hive.");
  }

  static Future<void> closeCartBox() async {
    await cartBox.close();
  }

  static Future<void> clearCartBox() async {
    await cartBox.clear();
  }
}
