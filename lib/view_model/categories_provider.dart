import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:perfumes_app/model/category_model.dart';
import 'package:perfumes_app/repo/categories_service.dart';

class CategoryProvider with ChangeNotifier {
  final ApiService _apiService;
  Map<String, Category>? _categories;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  Map<String, Category>? get categories => _categories;

  CategoryProvider() : _apiService = ApiService(CategoryService(Dio()));

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await _apiService.getCategories();
    } catch (error) {
      print("Error fetching categories: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
