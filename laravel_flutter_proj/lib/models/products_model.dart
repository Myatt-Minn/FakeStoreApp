import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:laravel_flutter_proj/models/categories_model.dart';

class ProductsModel with ChangeNotifier {
  int? id;
  String? title;
  int? price;
  String? description;
  List<String>? images;
  CategoriesModel? category;

  ProductsModel(
      {this.id,
      this.title,
      this.price,
      this.description,
      this.images,
      this.category});

  ProductsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    description = json['description'];
    images = _parseImages(json['images']);
    category = json['category'] != null
        ? CategoriesModel.fromJson(json['category'])
        : null;
  }
  static List<ProductsModel> productsfromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return ProductsModel.fromJson(data);
    }).toList();
  }

  List<String>? _parseImages(dynamic imagesJson) {
    if (imagesJson is List) {
      return imagesJson.expand((image) {
        if (image is String) {
          // Decode the JSON string to get the actual list of images
          List<dynamic> decodedImages = json.decode(image);
          return decodedImages.cast<String>();
        }
        return [image.toString()];
      }).toList();
    }
    return null;
  }
}
