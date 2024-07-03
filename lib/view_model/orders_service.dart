import 'package:firebase_database/firebase_database.dart';
import 'package:perfumes_app/model/purchased_model.dart';

class OrdersService {
  final DatabaseReference _ordersRef = FirebaseDatabase.instance.ref('orders');

  // Add a new order
  Future<void> addOrder(PurchasedItem item) async {
    try {
      final orderRef =
          _ordersRef.child(item.itemId!); // Reference to a specific item
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

  // Get all orders
  Future<List<PurchasedItem>> getAllOrders() async {
    try {
      final snapshot = await _ordersRef.once();
      final data = snapshot.snapshot.value as Map?;
      if (data != null) {
        return data.entries.map((entry) {
          final itemData = entry.value as Map;
          return PurchasedItem(
            itemId: itemData['itemId'] as String?,
            itemName: itemData['itemName'] as String,
            image: itemData['image'] as String,
            price: itemData['price'] as int,
            description: itemData['description'] as String,
            quantity: itemData['quantity'] as int,
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

  // Update an existing order
  Future<void> updateOrder(PurchasedItem item) async {
    try {
      final orderRef = _ordersRef.child(item.itemId!);
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

  // Delete an existing order
  Future<void> deleteOrder(String itemId) async {
    try {
      final orderRef = _ordersRef.child(itemId);
      await orderRef.remove();
      print('Order deleted with ID: $itemId');
    } catch (e) {
      print('Error deleting order: $e');
    }
  }
}
