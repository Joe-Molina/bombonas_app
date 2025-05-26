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
      backgroundColor: const Color.fromARGB(255, 39, 39, 39),
      appBar: AppBar(
        title: Text("Ordenes", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 27, 27, 27),
      ),
      body: ordersList(),
    );
  }

  FutureBuilder<List<OrdersResponse>> ordersList() {
    _orders = repository.fetchOrders();

    return FutureBuilder(
      future: _orders,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text(
            "Error: ${snapshot.error}",
            style: TextStyle(color: Colors.white),
          );
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
          borderRadius: BorderRadius.circular(4),
          color: const Color.fromARGB(255, 20, 20, 20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            spacing: 10,
            children: [
              Text(order.client.name, style: TextStyle(color: Colors.white)),
              Row(children: [cantCilindros("10kg", order.orderDetail.kg10)]),
              Row(children: [cantCilindros("18kg", order.orderDetail.kg18)]),
              Row(children: [cantCilindros("21kg", order.orderDetail.kg21)]),
              Row(children: [cantCilindros("27kg", order.orderDetail.kg27)]),
              Row(children: [cantCilindros("43kg", order.orderDetail.kg43)]),
            ],
          ),
        ),
      ),
    ),
  );

  Container cantCilindros(String kg, int cantidad) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: .5),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Text(kg, style: TextStyle(color: Colors.white)),
            Text("$cantidad", style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
