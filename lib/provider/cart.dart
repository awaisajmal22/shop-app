import 'package:flutter/material.dart';

class CartItem{
  String? id = null;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price
    }
  );
}

class Cart with ChangeNotifier{
Map<String, CartItem> _items = {};
Map<String, CartItem> get items {
  return {..._items};
}

int get itemCount{
  return _items.length;
}

double get totalAmount{
  var total = 0.0;
  _items.forEach((key, value) { 
    total += value.price * value.quantity;
  });
  return total;
}
void removeItem(String pid){
  _items.remove(pid);
  notifyListeners();
}
void addItem(String productId, double price, String title){
  if(_items.containsKey(productId)){
    _items.update(productId,
     (value) => CartItem(
      id: value.id, 
      title: value.title, 
      quantity: value.quantity + 1, 
      price: value.price));
  }
  else {
    _items.putIfAbsent(productId, ()=> 
    CartItem(
    id: DateTime.now().toString(),
    title: title,
    price: price,
    quantity: 1
    ));
  }
  notifyListeners();
}

void clearCart(){
  _items = {};
  notifyListeners();
}

void undoItem(String productid){
  if(!_items.containsKey(productid)){
    return;
  }
  if(_items[productid]!.quantity > 1){
    _items.update(productid, (value) => CartItem(
      id: value.id, 
      title: value.title, 
      quantity: value.quantity - 1, 
      price: value.price
      )
      );
      
  }
  else {
    _items.remove(productid);
  }
  notifyListeners();
}
}
