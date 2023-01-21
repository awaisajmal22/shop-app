//@dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helpers/custom_route.dart';
import 'package:shop_app/provider/auth.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/order.dart';
import 'package:shop_app/provider/product.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';
import './provider/products.dart';
import 'screens/order_screen.dart';
import 'screens/product_overview_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver{
  // final List<Product> product = loadedProducts;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products> (
          update: (context, auth, previousProducts) => Products(
            auth.isToken,
            previousProducts == null ? [] : previousProducts.items,
            auth.userId
            ),
        ),
        ChangeNotifierProvider.value(
          value: Cart()
        ),
        ChangeNotifierProxyProvider<Auth, Order>(
          update: ((context, value, previousOrders) => Order(
            value.isToken, 
            previousOrders == null ? [] : previousOrders.orders,
            value.userId
            )
          )
          )
      ],
          child: Consumer<Auth>(builder: (context, auth, _) => MaterialApp(
            title: 'Shop App',
            theme: ThemeData(
              canvasColor: Colors.white.withOpacity(0.7),
              primarySwatch: Colors.blue,
              pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: CustomPageTransitionBuilder()
                }
              )
            ),
            home: auth.isAuth ? ProductOverViewScreen()
             : FutureBuilder(
              future: auth.tryAutoLogin(),
              builder: (context, authResult) => 
              authResult.connectionState == ConnectionState.waiting 
              ? SplashScreen() 
              : AuthScreen()
              ) ,
            routes: {
              ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
              CartScreen.routeName:(context) => CartScreen(),
              OrderScreen.routeName: (context) => OrderScreen(),
              UserProductScreen.routeName: (context) => UserProductScreen(),
              EditProductScreen.routeName: (context) => EditProductScreen()
            },
          ), 
          ),    
    );
  }
}

