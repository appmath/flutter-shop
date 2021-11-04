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
                  OrderButton(cart: cart),
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            primary: Theme.of(context).colorScheme.secondary),
        label: Text(
          'Order Now',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        icon: _isLoading
            ? const CircularProgressIndicator()
            : Icon(Icons.add_shopping_cart,
                color: Theme.of(context).colorScheme.primary),
        onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                await Provider.of<Orders>(context, listen: false).addOrder(
                  widget.cart.items.values.toList(),
                  widget.cart.totalAmount,
                );

                setState(() {
                  _isLoading = false;
                });
                widget.cart.clear();
              });
  }
}

// check if cart totalAmount is <= 0 or loading return null otherwise:
// function for setting the loading state to true before calling the provider
// call provider to use the addOrder function
// set loading to false.
// clear the cart

// (widget.cart.totalAmount <= 0 || _isLoading)
//           ? null
//           : () async {
//               setState(() {
//                 _isLoading = true;
//               });
//               await Provider.of<Orders>(context, listen: false).addOrder(
//                 widget.cart.items.values.toList(),
//                 widget.cart.totalAmount,
//               );
//               setState(() {
//                 _isLoading = false;
//               });
//               widget.cart.clear();
//             }
