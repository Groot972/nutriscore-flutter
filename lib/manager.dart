import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:nutriscore_flutter/Product.dart';

class NetworkManager {
  static final NetworkManager _instance = NetworkManager._internal();

  factory NetworkManager() {
    return _instance;
  }

  NetworkManager._internal();

  Future<Product> fetchProduct(String barcode) async {
    final apiUrl = ' https://api.formation-android.fr/v2/getProduct?barcode=$barcode';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print(jsonData);
      return Product(barcode: jsonData.barcode);
    } else {
      throw Exception('Failed to fetch product');
    }
  }
}