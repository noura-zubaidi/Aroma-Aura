import 'package:flutter/material.dart';

class CategoryCard extends StatefulWidget {
  final String image;
  final String name;
  final VoidCallback onTap;

  const CategoryCard({
    Key? key,
    required this.image,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                widget.image,
                fit: BoxFit.fill,
                height: 100,
                width: 100,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.name,
              style: const TextStyle(
                fontFamily: 'LibreRegular',
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
