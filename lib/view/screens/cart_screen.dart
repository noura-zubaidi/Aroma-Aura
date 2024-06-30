import 'package:flutter/material.dart';
import 'package:perfumes_app/core/constants/colors.dart';
import 'package:perfumes_app/model/category_model.dart';
import 'package:perfumes_app/model/purchased_model.dart';
import 'package:perfumes_app/view/screens/purchase_screen.dart';
import 'package:perfumes_app/view_model/purchase_provider.dart';

class CartScreen extends StatefulWidget {
  final CategoryItem item;

  const CartScreen({Key? key, required this.item}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _quantity = 1;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _addToCart() {
    final purchasedItem = PurchasedItem(
      name: widget.item.name,
      image: widget.item.image,
      price: widget.item.price,
      description: widget.item.description,
      quantity: _quantity,
    );

    // Save the purchased item
    PurchasedItemsProvider().addPurchasedItem(purchasedItem);

    // Navigate to MyPurchasedScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyPurchasedScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.item.name,
          style: const TextStyle(
            fontFamily: 'LibreRegular',
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(widget.item.image),
            const SizedBox(height: 16),
            Text(
              widget.item.name,
              style: const TextStyle(
                fontFamily: 'LibreRegular',
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.item.description,
              style: const TextStyle(
                fontFamily: 'LibreRegular',
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '\$${widget.item.price}',
              style: TextStyle(
                fontFamily: 'LibreRegular',
                fontSize: 24,
                color: log1,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: _decrementQuantity,
                ),
                Text('$_quantity', style: const TextStyle(fontSize: 20)),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _incrementQuantity,
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: Colors.white,
                ),
                onPressed: _addToCart,
                child: Text(
                  'Add to Cart',
                  style: TextStyle(
                    fontFamily: 'LibreRegular',
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: log1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
