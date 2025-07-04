import 'package:bombonas_app/components/relacion_dolar_boilvares_in_card.dart';
import 'package:bombonas_app/data/models/orders_response.dart';
import 'package:bombonas_app/utils/actualizar_pago.dart';
import 'package:bombonas_app/utils/eliminar_orden.dart';
import 'package:bombonas_app/utils/precios.dart';
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
              return OrderCard(order: ordersList[index], bcv: bcv);
            },
          ),
        );
      } else {
        return Text("no hay resultados");
      }
    },
  );
}

class OrderCard extends StatefulWidget {
  const OrderCard({super.key, required this.order, required this.bcv});
  final OrdersResponse order;
  final double bcv;

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool paid = false;
  @override
  void initState() {
    super.initState();
    // 4. Accede a los parámetros del StatefulWidget a través de 'widget'
    paid = widget.order.payment; // Inicializa el contador con el valor pasado
  }

  @override
  Widget build(BuildContext context) {
    OrdersResponse order = widget.order;
    double bcv = widget.bcv;
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, top: 1, bottom: 1),
      child: GestureDetector(
        onTap: () async {
          bool pagoActualizado = await actualizarPago(context, order, paid);
          if (pagoActualizado) {
            setState(() {
              paid = !paid;
            });
          }
        },
        onLongPress: () async {
          bool result = await deleteOrder(context, order.id);

          if (result) {
            // aca los eliminamos con algun estado heredado
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Orden ${order.id} eliminada con éxito.')),
            );
            // Aquí pones tu lógica para borrar la orden de la base de datos, etc.
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: const Color.fromARGB(153, 0, 0, 0),
            border: Border.all(
              color: paid
                  ? const Color.fromARGB(125, 76, 175, 79)
                  : const Color.fromARGB(120, 244, 67, 54),
            ),
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
                          ],
                        ),
                      ),
                    ),
                    relacionDolarBs(
                      order.orderDetail,
                      bcv,
                      Colors.green,
                      preciosVenta,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  spacing: 10,
                  children: [
                    Row(
                      children: [
                        cantCilindros(
                          "10kg",
                          order.orderDetail.kg10,
                          preciosVenta[0],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        cantCilindros(
                          "18kg",
                          order.orderDetail.kg18,
                          preciosVenta[1],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        cantCilindros(
                          "21kg",
                          order.orderDetail.kg21,
                          preciosVenta[2],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        cantCilindros(
                          "27kg",
                          order.orderDetail.kg27,
                          preciosVenta[3],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        cantCilindros(
                          "43kg",
                          order.orderDetail.kg43,
                          preciosVenta[4],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Padding orderCard(OrdersResponse order, double bcv, context) {
//   bool paid = order.payment;

//   return
// }

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
