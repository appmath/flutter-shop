import 'package:flutter/material.dart';
import 'package:flutter_shop/providers/orders.dart';
import 'package:flutter_shop/widgets/app_drawer.dart';
import 'package:flutter_shop/widgets/order_item_widget.dart';
import 'package:provider/provider.dart';

class OrdersScreenFuture extends StatefulWidget {
  static const routeName = '/orders-screen';

  @override
  State<OrdersScreenFuture> createState() => _OrdersScreenFutureState();
}

class _OrdersScreenFutureState extends State<OrdersScreenFuture> {
  late Future _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return // Probably need SafeArea()
        Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
        // backgroundColor: Colors.white,
      ),
      drawer: AppDrawer(),
      body:
          // TODO Add
          FutureBuilder(
              future: _ordersFuture,
              builder: (ctx, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (dataSnapshot.error != null) {
                    return const Center(
                      child: Text('An error occurred!'),
                    );
                  } else {
                    return Consumer<Orders>(
                      builder: (ctx, orderData, child) => ListView.builder(
                        itemBuilder: (context, index) =>
                            OrderItemWidget(order: orderData.orders[index]),
                        itemCount: orderData.orders.length,
                      ),
                    );
                  }
                }
              }),
    );
  }
}

// Description: consume HTTP resources
// URL: https://pub.dev/packages/http
// Install: flutter pub add http
// App: Angela's bitcoin_picker (src/mobile/flutter/learning/udemy/complete-flutter-app-development-bootcamp-with-dart/section-14/bitcoin_picker)

// Example:
// http.Response response = await http.get(Uri.parse(requestURL));

// Full example
// class CoinData {
//   Future getCoinData(String selectedCurrency) async {
//     Map<String, String> map = {};
//     for (var crypto in cryptoList) {
//       String requestURL =
//           '$coinAPIURL/$crypto/$selectedCurrency?apiKey=$apiKey';
//       // String requestURL = '$coinAPIURL/BTC/USD?apikey=$apiKey';
//       http.Response response = await http.get(Uri.parse(requestURL));
//
//       if (response.statusCode == 200) {
//         var decodedData = jsonDecode(response.body);
//         var lastPrice = decodedData['rate'];
//
//         map[crypto] = lastPrice.toStringAsFixed(0);
//       } else {
//         print(response.statusCode);
//         throw 'Problem with the get request';
//       }
//     }
//     print('Map: $map');
//     return map;
//   }
// }
