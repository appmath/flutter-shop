import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_shop/providers/cart.dart';
import 'package:flutter_shop/providers/orders.dart';
import 'package:flutter_shop/widgets/cart_item_widget.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  // Don't forget to add this route in your main.dart file (or whatever you are using to define your routes)
  static const routeName = '/cart-screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return // Probably need SafeArea()
        Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        // backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6!
                              .color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        primary: Theme.of(context).colorScheme.secondary),
                    label: Text(
                      'Order Now',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    icon: Icon(Icons.add_shopping_cart,
                        color: Theme.of(context).colorScheme.primary),
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false).addOrder(
                        cart.items.values.toList(),
                        cart.totalAmount,
                      );
                      cart.clear();
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          // DON'T FORGET TO SPECIFY THE itemCount!!!!
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                var cartItem = cart.items.values.toList()[index];
                return CartItemWidget(
                    id: cartItem.id,
                    title: cartItem.title,
                    quantity: cartItem.quantity,
                    price: cartItem.price);
              },
              itemCount: cart.itemCount,
            ),
          ),
        ],
      ),
    );
  }
}
