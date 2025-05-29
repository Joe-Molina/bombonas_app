import 'package:bombonas_app/data/models/bcv_response.dart';
import 'package:bombonas_app/data/models/orders_response.dart';
import 'package:bombonas_app/data/repository.dart';
import 'package:bombonas_app/screens/order_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//unUsed
FutureBuilder<List<OrdersResponse>> ordersList(ordenes, ordenesCargadas) {
  Future<BcvResponse> bcv = Repository().fetchBcv();

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
        // var ordersList = snapshot.data;
        return Expanded(
          child: FutureBuilder(
            future: bcv,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text(
                  "Error: ${snapshot.error}",
                  style: TextStyle(color: Colors.white),
                );
              } else if (snapshot.hasData) {
                // print("BCV: ${snapshot.data!.price}");
                return ListView.builder(
                  itemCount: ordenesCargadas.length,
                  itemBuilder: (context, index) {
                    if (ordenesCargadas != null) {
                      return orderCard(
                        ordenesCargadas[index],
                        snapshot.data!.price,
                        context,
                      );
                    } else {
                      return Text("Error");
                    }
                  },
                );
              } else {
                return Text("no hay resultados");
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

Padding orderCard(OrdersResponse order, double bcv, context) => Padding(
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
                Container(
                  decoration: BoxDecoration(
                    // border: Border.all(color: Colors.white, width: .5)
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.black,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 2,
                      bottom: 2,
                      left: 12,
                      right: 12,
                    ),
                    child: Row(
                      spacing: 10,
                      children: [
                        Text(
                          order.client.name,
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          DateFormat(
                            'dd/MM/yy',
                          ).format(DateTime.parse(order.date)),
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  "${((order.orderDetail.kg10 * 5.5) + (order.orderDetail.kg18 * 11) + (order.orderDetail.kg21 * 13) + (order.orderDetail.kg27 * 16) + (order.orderDetail.kg43 * 24))}\$ / ${(((order.orderDetail.kg10 * 5.5) + (order.orderDetail.kg18 * 11) + (order.orderDetail.kg21 * 13) + (order.orderDetail.kg27 * 16) + (order.orderDetail.kg43 * 24)) * bcv).toStringAsFixed(2)} Bs.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 10,
              children: [
                Row(
                  children: [
                    cantCilindros("10kg", order.orderDetail.kg10, 5.5),
                  ],
                ),
                Row(
                  children: [cantCilindros("18kg", order.orderDetail.kg18, 11)],
                ),
                Row(
                  children: [cantCilindros("21kg", order.orderDetail.kg21, 13)],
                ),
                Row(
                  children: [cantCilindros("27kg", order.orderDetail.kg27, 16)],
                ),
                Row(
                  children: [cantCilindros("43kg", order.orderDetail.kg43, 24)],
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  ),
);

Container cantCilindros(String kg, int cantidad, double precio) {
  return Container(
    decoration: BoxDecoration(
      // border: Border.all(color: Colors.white, width: .5)
      borderRadius: BorderRadius.circular(5.0),
      color: Colors.grey[900],
    ),
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          Text(kg, style: TextStyle(color: Colors.white)),
          Text(
            "$cantidad ${cantidad * precio > 0 ? "/ ${formatDouble(cantidad * precio)}\$" : ""}",
            style: TextStyle(color: Colors.white),
          ),
          // Text("", style: TextStyle(color: Colors.white)),
        ],
      ),
    ),
  );
}

String formatDouble(double value) {
  if (value % 1 == 0) {
    // Si no tiene decimales (ej. 10.0, 5.0), lo convertimos a entero
    return value.toInt().toString();
  } else {
    // Si tiene decimales (ej. 10.5, 5.25), lo mostramos tal cual
    return value.toString();
  }
}
