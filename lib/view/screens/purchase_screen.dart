import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:perfumes_app/core/constants/colors.dart';
import 'package:perfumes_app/data/hive_helper.dart';
import 'package:perfumes_app/model/purchased_model.dart';
import 'package:perfumes_app/view_model/orders_service.dart';

class MyPurchasedScreen extends StatefulWidget {
  @override
  State<MyPurchasedScreen> createState() => _MyPurchasedScreenState();
}

class _MyPurchasedScreenState extends State<MyPurchasedScreen> {
  final OrdersService _ordersService =
      OrdersService(); // Instantiate OrdersService

  @override
  void initState() {
    super.initState();
    HiveHelper.init();
    _fetchPurchasedItems(); // Fetch purchased items from Firebase
  }

  // Fetch purchased items from Firebase and add them to Hive
  Future<void> _fetchPurchasedItems() async {
    final purchasedItems = await _ordersService.getAllOrders();
    final box = Hive.box<PurchasedItem>('cartBox');

    for (var item in purchasedItems) {
      // Only add items that are not already in the Hive box
      if (box.values.any((element) => element.itemId == item.itemId)) {
        continue;
      }
      await HiveHelper.addPurchasedItem(item);
    }

    setState(() {}); // Refresh the UI
  }

  // Handle checkout functionality
  Future<void> _handleCheckout() async {
    final box = Hive.box<PurchasedItem>('cartBox'); // Get the cart box

    if (box.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No items to checkout.'),
        ),
      );
      return;
    }

    // Get the list of items to delete
    final itemsToDelete = box.values.toList();
    for (var item in itemsToDelete) {
      await _ordersService.deleteOrder(item.itemId!); // Remove from Firebase
    }
    await HiveHelper.clearCartBox(); // Clear local Hive cart box

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Checkout successful.'),
      ),
    );

    // Optionally, refresh the purchased items list from Firebase
    await _fetchPurchasedItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Purchased Items',
          style: TextStyle(
            fontFamily: 'LibreRegular',
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ValueListenableBuilder<Box<PurchasedItem>>(
          valueListenable: Hive.box<PurchasedItem>('cartBox').listenable(),
          builder: (context, box, _) {
            final purchasedItems = box.values.toList();

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: purchasedItems.length,
                    itemBuilder: (context, index) {
                      final item = purchasedItems[index];
                      return Dismissible(
                        key: ValueKey(item.itemId),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) async {
                          await _ordersService.deleteOrder(
                              item.itemId!); // Remove from Firebase
                          await HiveHelper.removePurchasedItem(
                              item.itemId!); // Remove from local Hive storage
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${item.itemName} removed'),
                            ),
                          );
                        },
                        background: Container(
                          decoration: BoxDecoration(
                            color: log1,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: EdgeInsets.only(right: 20.0),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                                size: 36.0,
                              ),
                            ),
                          ),
                        ),
                        child: ListTile(
                          leading: Image.network(item.image),
                          title: Text(
                            item.itemName,
                            style: const TextStyle(
                              fontFamily: 'LibreRegular',
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            '\$${item.price} x${item.quantity}',
                            style: const TextStyle(
                              fontFamily: 'LibreRegular',
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _handleCheckout, // Call the checkout method
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                        'Checkout',
                        style: TextStyle(
                          fontFamily: 'LibreRegular',
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          color: log1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
