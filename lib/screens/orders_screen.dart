import 'package:bombonas_app/components/app_bar.dart';
import 'package:bombonas_app/screens/create_order_screen.dart';
import 'package:bombonas_app/components/date_bar.dart';
import 'package:bombonas_app/components/order_card.dart';
import 'package:bombonas_app/data/models/orders_response.dart';
import 'package:bombonas_app/data/repository.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // Future<List<OrdersResponse>>? _orders;
  Repository repository = Repository();
  Future<List<OrdersResponse>> ordenes = Repository().fetchOrders();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 39, 39, 39),
      appBar: appBarComponent("Ordenes"),
      body: Column(children: [dateBar(), ordersList(ordenes)]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateOrderScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
