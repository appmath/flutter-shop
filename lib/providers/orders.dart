import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'cart.dart';
import 'package:http/http.dart' as http;

const url = 'https://flutter-shop-aziz-default-rtdb.firebaseio.com/orders.json';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.amount,
      required this.products,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders => [..._orders];

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    // create timestamp
    // make the post request: amount, product (id, title, quantity, price) and dateTime
    final timestamp = DateTime.now();

    final response = await http.post(Uri.parse(url),
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'product': cartProducts
              .map((cartItem) => {
                    'id': cartItem.id,
                    'title': cartItem.title,
                    'quantity': cartItem.quantity,
                    'price': cartItem.price,
                  })
              .toList(),
        }));

    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartProducts,
            dateTime: timestamp));

    // insert orders, the id is from the response body (parse and get the...key)

    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final response = await http.get(Uri.parse(url));
    print(json.decode(response.body));
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['product'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price']))
              .toList(),
          dateTime: DateTime.parse(orderData['dateTime'])));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
  // Future<void> addOrder2(List<CartItem> cartProducts, double total) async {
  //   print('cartProducts: ${cartProducts[0].title} ,  total: $total');
  //   final timestamp = DateTime.now();
  //   final response = await http.post(Uri.parse(url),
  //       body: json.encode({
  //         'amount': total,
  //         'dateTime': timestamp.toIso8601String(),
  //         'product': cartProducts
  //             .map((cp) => {
  //                   'id': cp.id,
  //                   'title': cp.title,
  //                   'quantity': cp.quantity,
  //                   'price': cp.price
  //                 })
  //             .toList(),
  //       }));
  //   _orders.insert(
  //       0,
  //       OrderItem(
  //           id: json.decode(response.body)['name'],
  //           amount: total,
  //           products: cartProducts,
  //           dateTime: timestamp));
  //   notifyListeners();
  // }
}
