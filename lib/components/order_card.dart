import 'package:bombonas_app/data/models/orders_response.dart';
import 'package:bombonas_app/screens/order_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

FutureBuilder<List<OrdersResponse>> ordersList(ordenes) {
  // _orders = repository.fetchOrders();

  return FutureBuilder(
    future: ordenes,
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
                return orderCard(ordersList[index], context);
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

Padding orderCard(OrdersResponse order, context) => Padding(
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
        child: Column(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(order.client.name, style: TextStyle(color: Colors.white)),
                Column(
                  children: [
                    Text(
                      DateFormat('dd/MM/yy').format(DateTime.parse(order.date)),
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(children: [cantCilindros("10kg", order.orderDetail.kg10)]),
                Row(children: [cantCilindros("18kg", order.orderDetail.kg18)]),
                Row(children: [cantCilindros("21kg", order.orderDetail.kg21)]),
                Row(children: [cantCilindros("27kg", order.orderDetail.kg27)]),
                Row(children: [cantCilindros("43kg", order.orderDetail.kg43)]),
              ],
            ),
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
