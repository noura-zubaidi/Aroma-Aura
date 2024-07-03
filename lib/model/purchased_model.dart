import 'package:hive/hive.dart';

part 'purchased_model.g.dart';

@HiveType(typeId: 1)
class PurchasedItem extends HiveObject {
  @HiveField(0)
  final String? itemId;
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

  PurchasedItem({
    this.itemId,
    required this.itemName,
    required this.image,
    required this.price,
    required this.description,
    required this.quantity,
  });
  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'itemName': itemName,
      'image': image,
      'price': price,
      'description': description,
      'quantity': quantity,
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
    );
  }
}
