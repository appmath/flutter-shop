import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_shop/providers/orders.dart';
import 'package:intl/intl.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderItem order;

  OrderItemWidget({required this.order});

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    // Example: flutter_shop
    //           src/mobile/flutter/learning/udemy/flutter-dart-complete-guide/flutter_shop
    // final deviceSize = MediaQuery.of(context).size;

    // TODO Use this as a reference
    return AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height:
            _expanded ? min(widget.order.products.length * 20 + 110, 200) : 95,
        curve: Curves.easeIn,
        margin: const EdgeInsets.all(10),
        child: Card(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              ListTile(
                title: Text('\$${widget.order.amount}'),
                subtitle: Text(DateFormat('MM/dd/yyyy hh:mm')
                    .format(widget.order.dateTime)),
                trailing: IconButton(
                  icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                ),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                height: _expanded
                    ? min(widget.order.products.length * 20 + 10, 100)
                    : 0,
                child: ListView(
                  children: widget.order.products
                      .map(
                        (prod) => Row(
                          children: [
                            Text(
                              prod.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${prod.quantity}x \$${prod.price}',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ));
  }
}
