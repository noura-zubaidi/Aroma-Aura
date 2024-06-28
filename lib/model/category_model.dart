import 'package:json_annotation/json_annotation.dart';
part 'category_model.g.dart';

@JsonSerializable()
class Category {
  final String name;
  final String image;
  final List<CategoryItem> items;

  Category({
    required this.name,
    required this.image,
    required this.items,
  });

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}

@JsonSerializable()
class CategoryItem {
  final String name;
  final String image;
  final String description;
  final int price;

  CategoryItem(
      {required this.name,
      required this.image,
      required this.description,
      required this.price});

  factory CategoryItem.fromJson(Map<String, dynamic> json) =>
      _$CategoryItemFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryItemToJson(this);
}
