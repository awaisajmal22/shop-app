import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/user_product.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/product_overview_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';

import '../helpers/custom_route.dart';
import '../provider/auth.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colorizeColors = [
  Colors.black,
  Colors.red,
  Colors.blue,
  Colors.yellow,
  Colors.black12
];
    return Drawer(
      child: Column(
        children: [
          Card(
            elevation: 6,
            child: Container(
              color: Colors.white,
              height: 150,
              width: double.infinity,
              child: Stack(
                children: [
                  Center(
                    child: AnimatedTextKit(
  animatedTexts: [
    ColorizeAnimatedText(
      'Shop App',
      colors: colorizeColors,
      textStyle: const TextStyle(
        fontSize: 32.0,
        fontFamily: 'Monoton',
        letterSpacing: 2,
        wordSpacing: 6
      ),
      speed: const Duration(milliseconds: 300),
    ),
  ],
  repeatForever: true,
  displayFullTextOnTap: true,
  stopPauseOnTap: true,
)
)
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          buildDrawerListTile(
            context,
            'Shop',
          (){
            Navigator.of(context).pushReplacementNamed(
                '/');
          },
          Icons.shop
          ),
          buildDrawerListTile(
            context, 
            'Orders', 
            (){
              Navigator.of(context).pushReplacementNamed(
                OrderScreen.routeName
              );
              
            }, 
            Icons.payment
            ),
            buildDrawerListTile(
              context, 
              'Manage\nProducts', 
              (){
                Navigator.of(context).pushReplacementNamed(
                  UserProductScreen.routeName
                );
              },
              Icons.edit 
              ),
              Spacer(),
              buildDrawerListTile(
                context,
               'Logout', 
               (){
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Auth>(context, listen: false).logout();
                
               },
               Icons.exit_to_app)
        ],
      )
    );
  }

  Card buildDrawerListTile(BuildContext context, String title, Function push, IconData icon) {
    return Card(
          child: ListTile(
            leading: Icon(icon),
            contentPadding: EdgeInsets.only(left: 50),
            title: Text(title,
            style: TextStyle(
                    fontFamily: 'Monoton',
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                  ),
            ),
            onTap: ()=> push(),
          ),
        );
  }
}