import 'package:flutter/material.dart';
import 'package:flutter_shop/providers/cart.dart';
import 'package:flutter_shop/providers/products.dart';
import 'package:flutter_shop/widgets/app_drawer.dart';
import 'package:flutter_shop/widgets/bagde.dart';
import 'package:flutter_shop/widgets/products_grid.dart';
import 'package:provider/provider.dart';

import 'cart_screen.dart';

enum FilterOptions { favorites, all }

class ProductOverviewScreen extends StatefulWidget {
  // Don't forget to add this route in your main.dart file (or whatever you are using to define your routes)

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavoritesOnly = false;
  var _isLoading = false;

  // Warning: use didChangeDependencies() for ModalRoute.of(context) or anything that's loaded/created during initState (too early)
  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });

    Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts()
        .then((_) => setState(() {
              _isLoading = false;
            }));

    // print('After fetch _isLoading: $_isLoading');

    // Future.delayed(Duration.zero).then((_) =>
    //     Provider.of<Products>(context, listen: false).fetchAndSetProducts());
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     Provider.of<Products>(context).fetchAndSetProducts();
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return // Probably need SafeArea()
        Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                  child: Text('Only Favorites'),
                  value: FilterOptions.favorites),
              const PopupMenuItem(
                  child: Text('Show All'), value: FilterOptions.all),
            ],
            onSelected: (FilterOptions filterOption) {
              if (filterOption == FilterOptions.favorites) {
                setState(() {
                  _showFavoritesOnly = true;
                });
              } else {
                setState(() {
                  _showFavoritesOnly = false;
                });
              }
            },
          ),
          // Note that child might be tied to the main widget, it doesn't get updated
          Consumer<Cart>(
            builder: (_, cart, Widget? child) => Badge(
              child: child ?? buildIconButton(),
              value: cart.itemCount.toString(),
            ),
            child: buildIconButton(),
          ),
        ],
        // backgroundColor: Colors.white,
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ProductsGrid(showOnlyFavorites: _showFavoritesOnly),
    );
  }

  IconButton buildIconButton() {
    return IconButton(
      icon: const Icon(
        Icons.shopping_cart,
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(CartScreen.routeName);
      },
    );
  }
}
