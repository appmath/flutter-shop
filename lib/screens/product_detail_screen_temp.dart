import 'package:flutter/material.dart';
import 'package:flutter_shop/providers/products.dart';
import 'package:provider/provider.dart';

class ProductDetailScreenTemp extends StatelessWidget {
  // Don't forget to add this route in your main.dart file (or whatever you are using to define your routes)
  static const routeName = '/product-detail-screen';

  // TODO update Provider live template
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct = Provider.of<Products>(context).findById(productId);
    return // Probably need SafeArea()
        Scaffold(
      body: SafeArea(
        child: CustomScrollView(slivers: [
          SliverAppBar(
              pinned: true,
              expandedHeight: 150.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Available seats'),
                background: Image.network(
                  'https://r-cf.bstatic.com/images/hotel/max1024x768/116/116281457.jpg',
                  fit: BoxFit.fitWidth,
                ),
              )),
        ]),
      ),
    );
  }
}
