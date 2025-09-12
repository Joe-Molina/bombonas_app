import 'package:bombonas_app/components/relacion_dolar_boilvares_in_card.dart';
import 'package:bombonas_app/data/models/orders_response.dart';
import 'package:bombonas_app/presentation/providers/providers.dart';
import 'package:bombonas_app/utils/actualizar_pago.dart';
import 'package:bombonas_app/utils/precios.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderCard extends ConsumerStatefulWidget {
  const OrderCard({super.key, required this.order, required this.bcv});
  final OrdersResponse order;
  final double bcv;

  @override
  ConsumerState<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends ConsumerState<OrderCard> {
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
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 32, 32, 32),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.delete, color: Colors.white),
                        title: const Text(
                          'Eliminar esta orden',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () async {
                          // Espera a que la función asíncrona termine y obtén el resultado.
                          final bool isDeleted = await ref
                              .read(ordersProvider.notifier)
                              .deleteOrder(order.id);

                          // Es buena práctica verificar si el widget sigue "montado" (visible)
                          // antes de intentar usar su `context`.
                          if (context.mounted) {
                            if (isDeleted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Orden ${order.id} eliminada con éxito.',
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Orden ${order.id} no se pudo eliminar',
                                  ),
                                ),
                              );
                            }
                            // Opcional: Podrías añadir un `else` para mostrar un error si no se pudo borrar.
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
          // Aquí pones tu lógica para borrar la orden de la base de datos, etc.
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
