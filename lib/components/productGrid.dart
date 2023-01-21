// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/provider/product.dart';
import '../provider/products.dart';
import 'product_item.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  ProductGrid(this.showFavorite);
final bool showFavorite;

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products = showFavorite ? productData.favoriteItems : productData.items;
    if(products.isEmpty){
      return Container(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
               color: Colors.black45,
            ),
            height: 100,
            width: 300,
           
            child: Center(
              child: Text('No\t\t\tFavorite\t\t\titem Added\t\t\tYet\t\t\t!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Monoton',
                fontWeight: FontWeight.w500,
                fontSize: 26
              ),
              ),
            )
            )
            ),
      );
    }
    else {
    return GridView.builder(
      itemCount: products.length,
      padding: EdgeInsets.all(20),
      gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 1,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20, 
      ),
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductItems(),
      )
      );
    }
  }
}