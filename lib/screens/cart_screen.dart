import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/cart_item.dart';
import 'package:shop_app/provider/order.dart';

import '../provider/cart.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cartscreen';
  const CartScreen({Key? key, required this.showFavorite}) : super(key: key);
final bool showFavorite;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            elevation: 6,
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Padding(padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total',
                style: TextStyle(
                  fontSize: 26,
                  fontFamily: 'Monoton',
                  fontWeight: FontWeight.w500
                ),
                ),
                 Chip(
                  elevation: 6,
                    label: Text('\$\t${cart.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 26,
                      fontFamily: 'Monoton',
                      fontWeight: FontWeight.w500
                    ),
                    )
                    ),
                    TextButtonWidget(cart: cart),
              ],
            ),
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) => CartItems(
                id: cart.items.values.toList()[index].id as String,
                price: cart.items.values.toList()[index].price, 
                quantity: cart.items.values.toList()[index].quantity, 
                title: cart.items.values.toList()[index].title, 
                remove: cart.items.keys.toList()[index],
              )
              ),
          )
        ],
      ),
    );
  }
}

class TextButtonWidget extends StatefulWidget {
  const TextButtonWidget({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<TextButtonWidget> createState() => _TextButtonWidgetState();
}

class _TextButtonWidgetState extends State<TextButtonWidget> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.totalAmount <= 0.0 || _isLoading) ? null : 
      () async {
          setState(() {
            _isLoading = true;
          });
        await Provider.of<Order>(context, listen: false).addOrder(
          widget.cart.items.values.toList(), 
          widget.cart.totalAmount
          );
          setState(() {
            _isLoading = false;
          });
          widget.cart.clearCart();
      },
      child: _isLoading ? CircularProgressIndicator() : Text('Order Now')
      );
  }
}