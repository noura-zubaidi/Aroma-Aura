import 'package:hive/hive.dart';

part 'purchased_model.g.dart';

@HiveType(typeId: 1)
class PurchasedItem extends HiveObject {
  @HiveField(0)
  String? itemId;

  @HiveField(1)
  final String itemName;

  @HiveField(2)
  final String image;

  @HiveField(3)
  final int price;

  @HiveField(4)
  final String description;

  @HiveField(5)
  final int quantity;

  @HiveField(6)
  String? userId;

  PurchasedItem({
    this.itemId,
    required this.itemName,
    required this.image,
    required this.price,
    required this.description,
    required this.quantity,
    this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'itemName': itemName,
      'image': image,
      'price': price,
      'description': description,
      'quantity': quantity,
      'userId': userId,
    };
  }

  factory PurchasedItem.fromMap(Map<dynamic, dynamic> map) {
    return PurchasedItem(
      itemId: map['itemId'],
      itemName: map['itemName'],
      image: map['image'],
      price: map['price'],
      description: map['description'],
      quantity: map['quantity'],
      userId: map['userId'],
    );
  }
}
