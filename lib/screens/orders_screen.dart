import 'package:bombonas_app/data/models/orders_response.dart';
import 'package:bombonas_app/data/repository.dart';
import 'package:bombonas_app/screens/order_detail.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future<List<OrdersResponse>>? _orders;
  Repository repository = Repository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ordenes")),
      body: ordersList(),
    );
  }

  FutureBuilder<List<OrdersResponse>> ordersList() {
    return FutureBuilder(
      future: _orders,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (snapshot.hasData) {
          var ordersList = snapshot.data;
          return Expanded(
            child: ListView.builder(
              itemCount: ordersList?.length,
              itemBuilder: (context, index) {
                if (ordersList != null) {
                  return itemOrder(ordersList[index]);
                } else {
                  return Text("Error");
                }
              },
            ),
          );
        } else {
          return Text("no hay resultados");
        }
      },
    );
  }

  Padding itemOrder(OrdersResponse order) => Padding(
    padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
    child: GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrderDetailScreen()),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.red,
        ),
        child: Column(children: [Text("client ${order.clientId}")]),
      ),
    ),
  );
}
