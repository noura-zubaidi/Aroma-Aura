import 'package:perfumes_app/model/category_model.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
part 'categories_service.g.dart';

@RestApi(baseUrl: "https://aroma-aura-default-rtdb.firebaseio.com/")
abstract class CategoryService {
  factory CategoryService(Dio dio, {String baseUrl}) = _CategoryService;

  @GET("/categories.json")
  Future<Map<String, Category>> getCategories();
}

class ApiService {
  final CategoryService _categoryService;

  ApiService(this._categoryService);

  Future<Map<String, Category>> getCategories() async {
    try {
      return await _categoryService.getCategories();
    } catch (e) {
      throw e;
    }
  }
}
