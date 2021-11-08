import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.price,
      this.isFavorite = false});

  Future<void> toggleFavoriteStatus(String? token, String? userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final url =
        'https://flutter-shop-aziz-default-rtdb.firebaseio.com/userFavorites/$userId/products/$id.json?auth=$token';
    try {
      final response =
          await http.put(Uri.parse(url), body: json.encode(isFavorite));
      if (response.statusCode >= 400) {
        _setFatValue(oldStatus);
      }
    } catch (e) {
      _setFatValue(oldStatus);

      print(e);
    }
  }

  void _setFatValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }
}
