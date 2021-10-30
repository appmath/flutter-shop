import 'package:flutter/material.dart';
import 'package:flutter_shop/providers/orders.dart';
import 'package:flutter_shop/widgets/app_drawer.dart';
import 'package:flutter_shop/widgets/order_item_widget.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  // Don't forget to add this route in your main.dart file (or whatever you are using to define your routes)
  static const routeName = '/orders-screen';

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);

    return // Probably need SafeArea()
        Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
        // backgroundColor: Colors.white,
      ),
      drawer: AppDrawer(),
      body: // DON'T FORGET TO SPECIFY THE itemCount!!!!
          ListView.builder(
        itemBuilder: (context, index) =>
            OrderItemWidget(order: orderData.orders[index]),
        itemCount: orderData.orders.length,
      ),
    );
  }
}
