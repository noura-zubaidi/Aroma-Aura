import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
      itemName: widget.item.name,
      image: widget.item.image,
      price: widget.item.price,
      description: widget.item.description,
      quantity: _quantity,
    );

    final box = Hive.box<PurchasedItem>('cartBox');
    box.add(purchasedItem);

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
      body: Center(
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
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              textAlign: TextAlign.center,
              'About Product:\n ${widget.item.description}',
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
            Container(
              width: 200,
              height: 50,
              decoration: BoxDecoration(
                  color: log1, borderRadius: BorderRadius.circular(30)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.remove,
                      color: Colors.white,
                    ),
                    onPressed: _decrementQuantity,
                  ),
                  Text('$_quantity',
                      style:
                          const TextStyle(fontSize: 20, color: Colors.white)),
                  IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: _incrementQuantity,
                  ),
                ],
              ),
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
                    fontSize: 18,
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
