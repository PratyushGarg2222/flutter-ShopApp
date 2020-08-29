import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../widgets/app_drawer.dart';
import '../screens/cart_screen.dart';
import '../providers/products_provider.dart';

enum FilterOptions {
  Favourites,
  All,
}

class ProductsOverviewScreeen extends StatefulWidget {
  @override
  _ProductsOverviewScreeenState createState() =>
      _ProductsOverviewScreeenState();
}

class _ProductsOverviewScreeenState extends State<ProductsOverviewScreeen> {
  var _showFavouritesOnly = false;
  var _isInit = true;

  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isLoading = true;
      Provider.of<Products>(context).fetchProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              if (selectedValue == FilterOptions.Favourites) {
                _showFavouritesOnly = true;
              } else {
                _showFavouritesOnly = false;
              }
              setState(() {});
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favourites'),
                value: FilterOptions.Favourites,
              ),
              PopupMenuItem(child: Text('Show All'), value: FilterOptions.All),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, child) => Badge(
              child: child,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showFavouritesOnly),
    );
  }
}
