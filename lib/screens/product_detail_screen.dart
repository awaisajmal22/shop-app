
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/product_overview_screen.dart';
import '../provider/cart.dart';
import '../provider/product.dart';
import '../provider/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/productDetail';
 
  @override
  Widget build(BuildContext context) {
   final products = ModalRoute.of(context)?.settings.arguments;
   final productDetail = Provider.of<Products>(context).findById(products.toString());
  //  final addToCart = Provider.of<Cart>(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(productDetail.title),
              background: Hero(
                tag: productDetail.id, 
                child: Image.network(productDetail.image,
                fit: BoxFit.cover,
                ),
                ),
            ),
          ),
          SliverList(delegate: SliverChildListDelegate(
            [
              SizedBox(height: 20,),
            Text(productDetail.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold
            ),
            ),
            Text('\$\t${productDetail.price}',
            style: TextStyle(
              fontFamily: 'Monoton',
              fontSize: 30,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Consumer<Cart>(
                builder: (context, val, ch) => TextButton.icon(
                  onPressed: (){
                    val.addItem(productDetail.id, productDetail.price, productDetail.title);
                  }, 
                  icon: Icon(Icons.shopping_cart), 
                  label: Text('Add to Cart')
                  ),
              ),
            ),
            ]
          )
          )
        ],
      ),
    );
  }
}