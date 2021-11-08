import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import './edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    print('Rebuilding....');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      // TODO Fix this, this code should work, but it's not
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (ctx, productsData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: productsData.items.length,
                          itemBuilder: (_, index) {
                            final productItem = productsData.items[index];
                            return Column(
                              children: [
                                UserProductItem(
                                  id: productItem.id!,
                                  title: productItem.title,
                                  imageUrl: productItem.imageUrl,
                                ),
                                Divider(),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
      ),

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
      //     }),
    );
  }
}

//           FutureBuilder(
//               future: $SOME_CALL_THAT_FINISHES_IN_FUTURE$,
//               builder: (ctx, dataSnapshot) {
//                 if (dataSnapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else {
//                   if (dataSnapshot.error != null) {
//                     return const Center(
//                       child: Text('An error occurred!'),
//                     );
//                   } else {
//                     return Consumer<$CHANGE_NOTIFIER_CLASS$>(
//                       builder: (ctx, $CHANGE_NOTIFIER_CLASS_LC$Data, child) => ListView.builder(
//                         itemBuilder: (context, index) =>
//                             $WIDGET_SCREEN_CLASS$(order: $CHANGE_NOTIFIER_CLASS_LC$Data.$LIST$[index]),
//                         itemCount: $CHANGE_NOTIFIER_CLASS_LC$.$LIST$.length,
//                       ),
//                     );
//                   }
//                 }
//               })

//           FutureBuilder(
//               future: Provider.of<Orders>(context, listen: false)
//                   .fetchAndSetOrders(),
//               builder: (ctx, dataSnapshot) {
//                 if (dataSnapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else {
//                   if (dataSnapshot.error != null) {
//                     return const Center(
//                       child: Text('An error occurred!'),
//                     );
//                   } else {
//                     return Consumer<Orders>(
//                       builder: (ctx, orderData, child) => ListView.builder(
//                         itemBuilder: (context, index) =>
//                             OrderItemWidget(order: orderData.orders[index]),
//                         itemCount: orderData.orders.length,
//                       ),
//                     );
//                   }
//                 }
//               })
