import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:laravel_flutter_proj/consts/api_consts.dart';
import 'package:laravel_flutter_proj/models/categories_model.dart';
import 'package:laravel_flutter_proj/models/products_model.dart';
import 'package:laravel_flutter_proj/models/users_model.dart';

class ApiHandler {
  static Future<List<dynamic>> getData(
      {required String? target, String? limit}) async {
    try {
      var uri = Uri.https(BASE_URL, '/api/v1/$target',
          target == "products" ? {"offset": "0", "limit": limit} : {});
      var response = await http.get(uri);
      var data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw data['message'];
      }
      List snap = [];
      for (var v in data) {
        snap.add(v);
      }

      return snap;
    } catch (err) {
      throw err.toString();
    }
  }

  static Future<List<ProductsModel>> getAllProduct(
      {required String limit}) async {
    List snap = await getData(target: "products", limit: limit);
    return ProductsModel.productsfromSnapshot(snap);
  }

  static Future<List<CategoriesModel>> getAllCategories() async {
    List snap = await getData(target: "categories");
    return CategoriesModel.categoriesfromSnapshot(snap);
  }

  static Future<List<UsersModel>> getAllUsers() async {
    List snap = await getData(target: "users");
    return UsersModel.usersfromSnapshot(snap);
  }

  static Future<ProductsModel> getProductById({required String? id}) async {
    try {
      var uri = Uri.https(
        BASE_URL,
        '/api/v1/products/$id',
      );
      var response = await http.get(uri);

      var data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw data['message'];
      }
      return ProductsModel.fromJson(data);
    } catch (err) {
      throw err.toString();
    }
  }
}
