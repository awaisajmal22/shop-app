import 'package:flutter/material.dart';
import 'dart:convert';
import '../models/httpException.dart';
import 'product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  
  final String authToken;
  final String userId;
  
  var loadedProducts;

Products(this.authToken, this.loadedProducts, this.userId);


  List<Product> get items {
    return [...loadedProducts];
  }
  List<Product> get favoriteItems {
    return loadedProducts.where((prodItem) => prodItem.isFavorite as bool).toList();
}



Product findById(String id){
  return loadedProducts.firstWhere((prod) => prod.id == id);
}


  Future<void> fetchProduct([bool filterByUser = false]) async {
    final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = Uri.parse('https://shop-app-39eb6-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString');
    try {
    final response = await http.get(url);
    final fetched = json.decode(response.body) as Map<String, dynamic>;
    if(fetched == null){
      return ;
    }
    
    url = Uri.parse('https://shop-app-39eb6-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken');
    final favoriteResource = await http.get(url);
    final favoriteData = json.decode(favoriteResource.body);
    final List<Product> loadedProductItem = [];
    fetched.forEach((prodId, prodData) { 
      loadedProductItem.add(Product(
        id: prodId, 
        title: prodData['title'], 
        description: prodData['description'], 
        price: prodData['price'], 
        image: prodData['image'],
        isFavorite: favoriteData == null ? false : favoriteData[prodId] ?? false
        ));
    });
    loadedProducts = loadedProductItem;
    notifyListeners();
    } catch(error){
      throw error;
    }
  }
  Future<void> addProduct(Product product) async {
    final url = Uri.parse('https://shop-app-39eb6-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try{
    final response = await http.post(url, body: json.encode({
      'title':product.title,
      'description': product.description,
      'image': product.image,
      'price': product.price,
      'creatorId': userId,
    })
    );
     final newProduct = Product(
      id: json.decode(response.body)['name'], 
      title: product.title, 
      description: product.description, 
      image: product.image, 
      price: product.price,
      );
      loadedProducts.add(newProduct);
      // items.insert(0, newProduct);
    notifyListeners();

    } catch(error){
      throw (error);
    }
   
    }

    Future<void> updateProduct(String id , Product newProduct) async {
      final prodIndex = loadedProducts.indexWhere((prod) => prod.id == id);
      if(prodIndex >= 0){
        final url = Uri.parse('https://shop-app-39eb6-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
        await http.patch(url, body: json.encode({
      'title':newProduct.title,
      'description': newProduct.description,
      'image': newProduct.image,
      'price': newProduct.price,
    }
        ));
      loadedProducts[prodIndex] = newProduct;
     
      notifyListeners();
      }
      else {
        print('...');
      }
    }
    Future<void> deleteProduct(String id) async {
      final url = Uri.parse('https://shop-app-39eb6-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
      final existingProductIndex = loadedProducts.indexWhere(
        (prod) => prod.id == id);
      Product? existingProduct = loadedProducts[existingProductIndex];
      loadedProducts.removeAt(existingProductIndex);
      notifyListeners();
      final response = await http.delete(url);
          if(response.statusCode >= 400){
            loadedProducts.insert(existingProductIndex, existingProduct);
            notifyListeners();
            throw HttpException('Could not Delete Product.');
          }
          existingProduct = null;
    }

  
}