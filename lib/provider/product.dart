import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier{
  late final String id;
  final String title, description, image;
  final double price;
  bool isFavorite;
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    this.isFavorite = false
  });
  void _setFav(bool newVal){
    isFavorite = newVal;
    notifyListeners();
  }
  Future<void> toggleFavorite(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse('https://shop-app-39eb6-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token');
  
    final response = await http.put(url, body: json.encode(
      isFavorite
    ));
    if(response.statusCode >= 400){
      _setFav(oldStatus);
    }
     
    
}
}

List<Product> loadedProducts = [
  // Product(
  //   id: 'a1', 
  //   title: 'T-Shirt', 
  //   description: 'Made by silk with New Addition', 
  //   price: 49.99, 
  //   image: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    

  //   ),
  //   Product(
  //   id: 'a2', 
  //   title: 'Trouser', 
  //   description: 'Made by Wool with New Addition', 
  //   price: 64.99, 
  //   image: 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    
  //   ),
  //   Product(
  //   id: 'a3', 
  //   title: 'Scarf', 
  //   description: 'Made by Wool with New Addition', 
  //   price: 29.99, 
  //   image: 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    
  //   ),
  //   Product(
  //   id: 'a4', 
  //   title: 'Frie-Pan', 
  //   description: 'Made by Iron with New Addition', 
  //   price: 99.99, 
  //   image: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    
  //   )
];

