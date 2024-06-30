import 'package:flutter/material.dart';
import 'package:perfumes_app/view_model/purchase_provider.dart';

class MyPurchasedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final purchasedItems = PurchasedItemsProvider().getPurchasedItems();

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
      body: ListView.builder(
        itemCount: purchasedItems.length,
        itemBuilder: (context, index) {
          final item = purchasedItems[index];
          return ListTile(
            leading: Image.network(item.image),
            title: Text(
              item.name,
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
          );
        },
      ),
    );
  }
}
