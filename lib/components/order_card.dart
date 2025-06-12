import 'package:bombonas_app/data/models/orders_response.dart';
import 'package:bombonas_app/utils/same_day.dart';
import 'package:bombonas_app/utils/sum_totals_orders_by_day.dart';
import 'package:flutter/material.dart';

//unUsed
FutureBuilder<List<OrdersResponse>> ordersList(
  Future<List<OrdersResponse>>? ordenes,
  TotalOrdersByDay ordenesCargadas,
  bcv,
) {
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
        var ordersList = snapshot.data!
            .where(
              (order) =>
                  sameDay(DateTime.parse(order.date), ordenesCargadas.date),
            )
            .toList();
        return Expanded(
          child: ListView.builder(
            itemCount: ordersList.length,
            itemBuilder: (context, index) {
              return orderCard(ordersList[index], bcv, context);
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
  padding: const EdgeInsets.only(left: 4, right: 4, top: 1, bottom: 1),
  child: GestureDetector(
    // onTap: () => Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => HomeScreen()),
    // ),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: const Color.fromARGB(153, 0, 0, 0),
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
                    color: const Color.fromARGB(255, 53, 53, 53),
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
                        // Text(
                        //   DateFormat(
                        //     'dd/MM/yy',
                        //   ).format(DateTime.parse(order.date)),
                        //   style: TextStyle(fontSize: 12, color: Colors.white),
                        // ),
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
      // color: Colors.grey[900],
    ),
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          Text(
            "${formatDouble(cantidad * precio)}\$",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          Text(
            "$cantidad ${cantidad * precio > 0 ? "/ $kg" : ""}",
            style: TextStyle(
              color: const Color.fromARGB(255, 104, 104, 105),
              fontSize: 12,
            ),
          ),
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
