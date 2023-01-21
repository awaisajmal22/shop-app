import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../provider/cart.dart';
import '../provider/product.dart';

class CartItems extends StatelessWidget {
  const CartItems({Key? key, required this.id, required this.price, required this.title, required this.quantity, required this.remove}) : super(key: key);
  final String id;
  final double price;
   final String title;
   final int quantity;
   final String remove;
   

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Card(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.blue
            ),
            height: 60,
            width: 60,
            child: FittedBox(
              child: Text(
                '\$\t${price}',
              ),
            ),
          ),
          title: Text(title,
          textAlign: TextAlign.center,
          ),
          subtitle: Chip(

            label: Text('${quantity} x',
            style: TextStyle(
              color: Colors.black
            ),
            ),
          ),
          trailing: ElevatedButton.icon(
           onPressed: (){
            showDialog(context: context, 
            builder: (context) => AlertDialog(
              content: Text('Do you want to Remove the item from Cart !'),
              title: Text('Are You Sure ?'),
              actions: [
                TextButton(
                  onPressed: (){
                      Provider.of<Cart>(context, listen: false).removeItem(remove);
                      Navigator.of(context).pop(true);
                  }, 
                child: const Text('Yes')
                ),
                TextButton(
                  onPressed: (){
                    Navigator.of(context).pop(false);
                  }, 
                  child: Text('No')
                  )
              ],
            ),
             
            );
          
            
           }, 
            icon: Icon(Icons.delete),
             label: Text('Delete')
             ),
        ),
      ),
    );
  }
}