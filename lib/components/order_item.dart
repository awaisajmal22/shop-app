import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../provider/order.dart';
class OrderItems extends StatefulWidget {
  const OrderItems({Key? key, required this.order, }) : super(key: key);
final OrderItem order;




  @override
  State<OrderItems> createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  var _expand = false;
  
  @override
  Widget build(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$\t${widget.order.amount.toStringAsFixed(2)}',
            style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Monoton',
                        fontWeight: FontWeight.w600
                      ),
            ),
            subtitle: Text(DateFormat('dd MM yyy hh:mm').format(widget.order.dateTime)),
            onTap:  (){
                setState(() {
                  _expand = !_expand;
                });
              },
              trailing: IconButton(
                 onPressed: () async {
                try{
                await Provider.of<Order>(context, listen: false).deleteOrder(widget.order.id);
                } catch(error){
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text('Deleting Faild', textAlign: TextAlign.center,) ,
                    )
                  );
                }
                 } ,
              icon: Icon(Icons.delete)
              ),
          ),
          if(_expand) Container(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            height: min(
              widget.order.products.length * 20 + 20, 180
             ),
             child: ListView(
              padding: EdgeInsets.only(bottom: 10),
              children: widget.order.products.map(
                (prod) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(prod.title,
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Monoton',
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      '${prod.quantity}x\t\t\t\t\t\$${prod.price}',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Monoton',
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                  )
              ).toList()
             ),
          )
        ],
      ),
    );
  }
}