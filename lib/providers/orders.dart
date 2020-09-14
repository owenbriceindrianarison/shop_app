import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:shop_app/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  const OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    const url = 'https://shop-app-5e7fe.firebaseio.com/orders.json';
    final response = await http.get(url);
    final extradedData = jsonDecode(response.body) as Map<String, dynamic>;
    if (extradedData == null) {
      return;
    }
    final List<OrderItem> loadedOrders = [];
    extradedData.forEach(
      (orderId, orderData) {
        loadedOrders.add(
          OrderItem(
            id: orderId,
            amount: orderData['amount'],
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    price: item['price'],
                    quantity: item['quantity'],
                  ),
                )
                .toList(),
            dateTime: DateTime.parse(
              orderData['dateTime'],
            ),
          ),
        );
      },
    );
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url = 'https://shop-app-5e7fe.firebaseio.com/orders.json';
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: jsonEncode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList()
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: timestamp,
      ),
    );
    notifyListeners();
  }
}
