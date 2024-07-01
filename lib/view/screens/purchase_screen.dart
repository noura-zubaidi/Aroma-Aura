import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:perfumes_app/core/constants/colors.dart';
import 'package:perfumes_app/data/hive_helper.dart';
import 'package:perfumes_app/model/purchased_model.dart';
import 'package:perfumes_app/view_model/purchase_provider.dart';

class MyPurchasedScreen extends StatelessWidget {
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
          valueListenable: HiveHelper.cartBox.listenable(),
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
                          await HiveHelper.removePurchasedItem(item.itemId!);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${item.itemName} removed'),
                            ),
                          );
                        },
                        background: Container(
                          decoration: BoxDecoration(
                              color: log1,
                              borderRadius: BorderRadius.circular(10)),
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
                      onPressed: () {},
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
}
