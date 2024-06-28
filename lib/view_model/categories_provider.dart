import 'package:flutter/material.dart';
import 'package:perfumes_app/model/category_model.dart';
import 'package:perfumes_app/repo/categories_service.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryService categoryService;
  List<Category> _categories = [];
  bool _isLoading = false;

  CategoryProvider(this.categoryService);

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      final fetchedCategories = await categoryService.getCategories();
      _categories = fetchedCategories;
    } catch (error) {
      print("Error fetching categories: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
