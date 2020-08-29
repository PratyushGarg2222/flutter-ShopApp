import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
  });

  Future<void> toggleFavouriteStatus(String token, String userId) async {
    isFavourite = !isFavourite;
    notifyListeners();

//Changed so that favourite only for specific user
    final url =
        "https://shop-app-df227.firebaseio.com/userFavorites/$userId/$id.json?auth=$token";

    try {
      final response = await http
          .put(
        url,
        body: json.encode(
          isFavourite,
        ),
      )
          .then((response) {
        if (response.statusCode >= 400) {
          isFavourite = !isFavourite;
          notifyListeners();
        }
      }).catchError((error) {
        isFavourite = !isFavourite;
        notifyListeners();
      });
    } catch (error) {
      throw (error);
    }
  }
}
