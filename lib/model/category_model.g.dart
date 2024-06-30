// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      name: json['name'] as String,
      image: json['image'] as String,
      items: (json['items'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, CategoryItem.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'name': instance.name,
      'image': instance.image,
      'items': instance.items,
    };

CategoryItem _$CategoryItemFromJson(Map<String, dynamic> json) => CategoryItem(
      name: json['name'] as String,
      image: json['image'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toInt(),
    );

Map<String, dynamic> _$CategoryItemToJson(CategoryItem instance) =>
    <String, dynamic>{
      'name': instance.name,
      'image': instance.image,
      'description': instance.description,
      'price': instance.price,
    };
