import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:perfumes_app/core/constants/colors.dart';
import 'package:perfumes_app/model/category_model.dart';
import 'package:perfumes_app/model/purchased_model.dart';
import 'package:perfumes_app/view/screens/purchase_screen.dart';
import 'package:perfumes_app/view_model/orders_service.dart';
import 'package:perfumes_app/view_model/purchase_provider.dart';
import 'package:uuid/uuid.dart';

class CartScreen extends StatefulWidget {
  final CategoryItem item;

  const CartScreen({Key? key, required this.item}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _quantity = 1;
  final OrdersService _ordersService =
      OrdersService(); // Instantiate OrdersService
  final Uuid _uuid = Uuid(); // Instantiate Uuid for generating unique IDs

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

  Future<void> _addToCart() async {
    final itemId = _uuid.v4(); // Generate a unique ID
    final purchasedItem = PurchasedItem(
      itemId: itemId,
      itemName: widget.item.name,
      image: widget.item.image,
      price: widget.item.price,
      description: widget.item.description,
      quantity: _quantity,
    );

    final box = Hive.box<PurchasedItem>('cartBox');
    await box.add(purchasedItem);

    await _ordersService.addOrder(purchasedItem); // Add the item to Firebase

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
        child: SingleChildScrollView(
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
                  fontSize: 28,
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
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30)),
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
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: Colors.black,
                  ),
                  onPressed: _addToCart,
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(
                      fontFamily: 'LibreRegular',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
