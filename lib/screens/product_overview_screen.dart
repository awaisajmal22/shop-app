import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/main_drawer.dart';
import 'package:shop_app/components/product_item.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/screens/splash_screen.dart';

import '../components/badge.dart';
import '../components/productGrid.dart';
import '../provider/cart.dart';
import '../provider/products.dart';
enum favoriteOption{
  Favorites,
  All,
}

// ignore: must_be_immutable
class ProductOverViewScreen extends StatefulWidget {


  @override
  State<ProductOverViewScreen> createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {
  var _showFavorite = false;
  var _isinit = true;
  var _isLoading = false;

  @override
  void initState() {
    // Provider.of<Products>(context).fetchProduct(); //wont work
    // Future.delayed(Duration.zero).then(
    //   (_) {
    //     Provider.of<Products>(context).fetchProduct();
    // });
    super.initState();
  }
  @override
  void didChangeDependencies() {
    if(_isinit){
      setState(() {
  _isLoading = true;
});
      Provider.of<Products>(context).fetchProduct()
      .then((_){
        _isLoading = false;
      });
    }
    setState(() {
  _isinit = false;
});
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text('Shop App'),
        actions: [
          Consumer<Cart>(
            builder: (_, val , ch) => Badge(
              child: ch,
              value: val.itemCount.toString(),
              color: Colors.black38
            ),
            child: IconButton(
                onPressed: (){
                  Navigator.of(context).pushNamed(
                    CartScreen.routeName,
                  );
                },
                icon: Icon(Icons.shopping_cart),
                ),
          ),
          PopupMenuButton(
            onSelected: (favoriteOption selected){
              setState(() {
             if(selected == favoriteOption.Favorites){
             _showFavorite = true;
                   } else {
             _showFavorite = false;
            }
                 });
              
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
            
            PopupMenuItem(
              value: favoriteOption.Favorites,
              child: Text('Favorites Only'),
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: favoriteOption.All,
              )
          ]),
          
        ],
      ),
      body: _isLoading ? Center(
        child: SplashScreen(),
      ) : ProductGrid(_showFavorite)
    );
  }
}

