

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product.dart';
import 'package:shop_app/screens/product_detail_screen.dart';

import '../provider/auth.dart';
import '../provider/cart.dart';
import '../provider/products.dart';

class ProductItems extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context , listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return  ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          splashColor: Colors.blue,
    
          onTap:()=> Navigator.of(context).pushNamed(
            ProductDetailScreen.routeName,
            arguments: product.id,
          ),
          child: GridTile(
            footer: Container(
              margin: EdgeInsets.only(
                bottom: 10,
                left: 10,
                right: 10
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)
                ),
                child: GridTileBar(
                  leading: Consumer<Product>(
                    builder: (context, val, child) => IconButton(
                      onPressed: (){
                       val.toggleFavorite(authData.isToken as String, authData.userId as String);
                    }, 
                    icon:  Icon( product.isFavorite ? 
                    Icons.favorite : Icons.favorite_border
                    )
                    ),
                  ),
                  backgroundColor: Colors.black87,
                  title: Text(product.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'CabinSketch',
                    fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.center,
                  ),
                  trailing: IconButton(
                    splashColor: Colors.teal,
                    onPressed: (){
                      cart.addItem(
                        product.id, 
                        product.price, 
                        product.title
                        );
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Added Item to Cart !',textAlign: TextAlign.center,),
                          duration: Duration(seconds: 2),
                          dismissDirection: DismissDirection.horizontal,
                          action: SnackBarAction(
                            label: 'UNDO', 
                            onPressed: (){
                              cart.undoItem(product.id);
                            }
                            ),
                          ),
                        );
                    },
                   icon: Icon(
                    Icons.shopping_cart,
                    color: Theme.of(context).canvasColor,
                   )
                   ),
                ),
              ),
            ),
            child: Hero(
              tag: product.id,
              child: FadeInImage(
                placeholder: AssetImage('assets/images/shop.webp'),
              image: NetworkImage(product.image),
              fit: BoxFit.cover,
              ),
            ),
        ),
        )
    );
  }
}