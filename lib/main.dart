import 'package:flutter/material.dart';
import 'package:flutter_shop/providers/auth.dart';
import 'package:flutter_shop/providers/cart.dart';
import 'package:flutter_shop/providers/orders.dart';
import 'package:flutter_shop/providers/products.dart';
import 'package:flutter_shop/screens/auth_screen.dart';
import 'package:flutter_shop/screens/cart_screen.dart';
import 'package:flutter_shop/screens/edit_product_screen.dart';
import 'package:flutter_shop/screens/orders_screen.dart';
import 'package:flutter_shop/screens/product_detail_screen.dart';
import 'package:flutter_shop/screens/product_overview_screen.dart';
import 'package:flutter_shop/screens/splash_screen.dart';
import 'package:flutter_shop/screens/user_products_screen.dart';
import 'package:flutter_shop/utils/material_colors.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

// TODO update Provider live template

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products(authToken: '', userId: '', items: []),
          update: (ctx, auth, previousProducts) => Products(
              authToken: auth.token,
              userId: auth.userId,
              items: previousProducts == null ? [] : previousProducts.items),
        ),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders(authToken: '', userId: '', orders: []),
          update: (ctx, auth, previousOrders) => Orders(
              authToken: auth.token,
              userId: auth.userId,
              orders: previousOrders == null ? [] : previousOrders.orders),
        ),
      ],
      child: // Note that child might be tied to the main widget, it doesn't get updated
          Consumer<Auth>(
        builder: (BuildContext context, auth, Widget? _) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: greyMaterialColor,
            accentColor: orangeMaterialColor,
            canvasColor: const Color.fromRGBO(255, 254, 229, 1),
            fontFamily: 'Lato',
            textTheme: ThemeData.light().textTheme.copyWith(
                  bodyText1: const TextStyle(
                    color: Color.fromRGBO(20, 51, 51, 1),
                  ),
                  bodyText2: const TextStyle(
                    color: Color.fromRGBO(20, 51, 51, 1),
                  ),
                ),
          ),
          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),

          // Example:
          // FutureBuilder(
          //     future: Provider.of<Orders>(context, listen: false)
          //         .fetchAndSetOrders(),
          //     builder: (ctx, dataSnapshot) {
          //       if (dataSnapshot.connectionState == ConnectionState.waiting) {
          //         return const Center(child: CircularProgressIndicator());
          //       } else {
          //         if (dataSnapshot.error != null) {
          //           return const Center(
          //             child: Text('An error occurred!'),
          //           );
          //         } else {
          //           return Consumer<Orders>(
          //             builder: (ctx, orderData, child) => ListView.builder(
          //               itemBuilder: (context, index) =>
          //                   OrderItemWidget(order: orderData.orders[index]),
          //               itemCount: orderData.orders.length,
          //             ),
          //           );
          //         }
          //       }
          //     }) AuthScreen(),
          // initialRoute: ProductDetailScreen.routeName,
          routes: {
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrdersScreen.routeName: (context) => OrdersScreen(),
            UserProductsScreen.routeName: (context) => UserProductsScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
      ),
      body: Center(
        child: Text('Let\'s build a shop!'),
      ),
    );
  }
}
