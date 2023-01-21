import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shop_app/components/main_drawer.dart';
import 'package:shop_app/components/order_item.dart';
import 'package:shop_app/screens/splash_screen.dart';

import '../provider/order.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);
  static const routeName = '/orderScreen';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late Future _fetchData;
  Future fetchDatafromServer(){
    return Provider.of<Order>(context, listen: false).fetchOrder();
  }
  @override
  void initState() {
    _fetchData = fetchDatafromServer();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: MainDrawer(),
      body:  FutureBuilder(
        future: _fetchData,
        builder: (context, snapshot) {
          if(snapshot.connectionState ==  ConnectionState.waiting){
            return const Center(child: SplashScreen());
          }
          else{
           return Consumer<Order>(
          builder: (context, order, child) => ListView.builder(
          itemCount: order.orders.length,
          itemBuilder: (context, index) => OrderItems(
            order: order.orders[index],  
          ),
          )
           );
          }
        }
      )
        );
  }
}