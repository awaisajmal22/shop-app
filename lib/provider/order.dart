import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/provider/product.dart';
import 'cart.dart';

class OrderItem{
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

OrderItem({
  required this.id,
  required this.amount,
  required this.products,
  required this.dateTime
});
}

class Order with ChangeNotifier{
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;
  Order(this.authToken, this._orders, this.userId);

  List<OrderItem> get orders {
    return [..._orders];
  }
 

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    final url = Uri.parse('https://shop-app-39eb6-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final timest = DateTime.now();
    final response = await http.post(url, body: json.encode({
      'amount': total,
      'dateTime': timest.toIso8601String(),
      'products': cartProduct.map((cp) => {
          'id': cp.id,
          'title': cp.title,
          'quantity': cp.quantity,
          'price': cp.price
        }
        ).toList()
      
    }));
    _orders.insert(0, OrderItem(
      id: json.decode(response.body)['name'],
      amount: total, 
      products: cartProduct, 
      dateTime: timest
      )
      );
      notifyListeners();
  }

  Future<void> fetchOrder() async {
    final url = Uri.parse('https://shop-app-39eb6-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final response = await http.get(url);
    final List<OrderItem> loadedOrder = [];
    final fetchData = json.decode(response.body) as Map<String, dynamic>;
    if(fetchData == null){
      return;
    }
    fetchData.forEach((orderId, orderData) { 
      loadedOrder.add(OrderItem(
        id: orderId, 
        amount: orderData['amount'], 
        dateTime: DateTime.parse(orderData['dateTime']),
        products: (orderData['products'] as List<dynamic>).map((item) => 
          CartItem(
            id: item['id'], 
            title: item['title'], 
            quantity: item['quantity'], 
            price: item['price']
            )
        ).toList(), 
      )
      );
    });
    _orders = loadedOrder.reversed.toList();
    notifyListeners();
  }
  

  Future<void> deleteOrder(String id) async {
      final url = Uri.parse('https://shop-app-39eb6-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
      final existingProductIndex = _orders.indexWhere(
        (prod) => prod.id == id);
      OrderItem? existingOrder = _orders[existingProductIndex];
      _orders.removeAt(existingProductIndex);
      notifyListeners();
      final response = await http.delete(url);
          if(response.statusCode >= 400){
            _orders.insert(existingProductIndex, existingOrder);
            notifyListeners();
          }
          existingOrder = null;
    }

}