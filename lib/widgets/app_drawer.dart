import 'package:flutter/material.dart';

import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text('Hello Friend!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.shop,
            ),
            title: const Text('Shop'),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.payment,
            ),
            title: const Text('Orders'),
            onTap: () => Navigator.of(context).pushReplacementNamed(
              OrdersScreen.routeName,
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.edit,
            ),
            title: const Text('Manage Products'),
            onTap: () => Navigator.of(context).pushReplacementNamed(
              UserProductScreen.routeName,
            ),
          ),
        ],
      ),
    );
  }
}
