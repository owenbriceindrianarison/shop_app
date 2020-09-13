import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavoriteValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    var oldStatus = isFavorite;
    _setFavoriteValue(!isFavorite);
    final url = 'https://shop-app-5e7fe.firebaseio.com/products/$id.json';
    final response =
        await http.patch(url, body: json.encode({'isFavorite': isFavorite}));
    if (response.statusCode >= 400) {
      _setFavoriteValue(oldStatus);
      if (oldStatus) {
        throw HttpException('Could not set product to unfavorite!');
      } else {
        throw HttpException('Could not set product to favorite!');
      }
    }
    oldStatus = null;
  }
}
