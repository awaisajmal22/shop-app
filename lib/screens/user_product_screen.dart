import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/main_drawer.dart';
import 'package:shop_app/components/user_product.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';

import '../provider/products.dart';

class UserProductScreen extends StatefulWidget {
  static const routeName = '/userProductScreen';
  const UserProductScreen({Key? key}) : super(key: key);

  @override
  State<UserProductScreen> createState() => _UserProductScreenState();
}

class _UserProductScreenState extends State<UserProductScreen> {
  // final String id;
  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Product'),
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).pushNamed(
              EditProductScreen.routeName,
            );
          }, icon:Icon(Icons.add))
        ],
      ),
      drawer: MainDrawer(),
      body: FutureBuilder(
        future: _refreshProduct(context),
        builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting ? SplashScreen() : RefreshIndicator(
          onRefresh: ()=> _refreshProduct(context),
          child: Consumer<Products>(
            builder: (context, productsData, _) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: productsData.items.length,
                itemBuilder: (_, index) => Column(
                  children: [
                    UserPrdouct(
                      id: productsData.items[index].id,
                      title: productsData.items[index].title, 
                      image: productsData.items[index].image, 
                      ),
                    Divider(
                      color: Colors.transparent,
                    )
                  ],
                )
                ),
            ),
          ),
        ),
      ),
    );
  }
}