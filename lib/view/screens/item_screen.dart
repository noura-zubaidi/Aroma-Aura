import 'package:flutter/material.dart';
import 'package:perfumes_app/model/category_model.dart';
import 'package:perfumes_app/view/screens/cart_screen.dart';

class ItemsScreen extends StatelessWidget {
  final Category category;

  const ItemsScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = category.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          category.name,
          style: const TextStyle(
            fontFamily: 'LibreRegular',
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
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
              '\$${item.price}',
              style: const TextStyle(
                fontFamily: 'LibreRegular',
                fontSize: 12,
                color: Colors.black,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(item: item),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
