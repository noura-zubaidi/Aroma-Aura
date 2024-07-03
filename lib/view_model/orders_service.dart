import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:perfumes_app/model/purchased_model.dart';

class OrdersService {
  final DatabaseReference _ordersRef = FirebaseDatabase.instance.ref('orders');

  String getUserOrdersPath() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      throw Exception('No user is logged in');
    }
    return 'users/$userId/orders';
  }

  Future<void> addOrder(PurchasedItem item) async {
    try {
      final orderRef = FirebaseDatabase.instance
          .ref('${getUserOrdersPath()}/${item.itemId}');
      await orderRef.set({
        'itemId': item.itemId,
        'itemName': item.itemName,
        'image': item.image,
        'price': item.price,
        'description': item.description,
        'quantity': item.quantity,
      });
      print('Order added: ${item.itemName}');
    } catch (e) {
      print('Error adding order: $e');
    }
  }

  Future<List<PurchasedItem>> getAllOrders() async {
    try {
      final snapshot =
          await FirebaseDatabase.instance.ref(getUserOrdersPath()).once();
      final data = snapshot.snapshot.value as Map?;
      if (data != null) {
        return data.entries.map((entry) {
          final itemData = entry.value as Map;
          return PurchasedItem(
            itemId: itemData['itemId'],
            itemName: itemData['itemName'],
            image: itemData['image'],
            price: itemData['price'],
            description: itemData['description'],
            quantity: itemData['quantity'],
          );
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching orders: $e');
      return [];
    }
  }

  Future<void> updateOrder(PurchasedItem item) async {
    try {
      final orderRef = FirebaseDatabase.instance
          .ref('${getUserOrdersPath()}/${item.itemId}');
      await orderRef.update({
        'itemName': item.itemName,
        'image': item.image,
        'price': item.price,
        'description': item.description,
        'quantity': item.quantity,
      });
      print('Order updated: ${item.itemName}');
    } catch (e) {
      print('Error updating order: $e');
    }
  }

  Future<void> deleteOrder(String itemId) async {
    try {
      final orderRef =
          FirebaseDatabase.instance.ref('${getUserOrdersPath()}/$itemId');
      await orderRef.remove();
      print('Order deleted with ID: $itemId');
    } catch (e) {
      print('Error deleting order: $e');
    }
  }
}
