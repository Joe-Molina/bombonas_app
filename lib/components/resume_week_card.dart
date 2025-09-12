import 'package:bombonas_app/components/order_card.dart';
import 'package:bombonas_app/components/relacion_dolar_boilvares_in_card.dart';
import 'package:bombonas_app/data/models/orders_response.dart';
import 'package:bombonas_app/presentation/providers/providers.dart';
import 'package:bombonas_app/screens/week_orders_screen.dart';
import 'package:bombonas_app/utils/precios.dart';
import 'package:bombonas_app/utils/same_day.dart';
import 'package:bombonas_app/utils/sum_totals_orders_by_day.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResumeCardWeek extends ConsumerWidget {
  const ResumeCardWeek({
    super.key,
    required this.context,
    this.futureOrders,
    required this.selectedWeek,
  });

  final BuildContext context;
  final Future<List<OrdersResponse>>? futureOrders;
  final DateTime selectedWeek;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<double> bcvValue = ref.watch(bcvProvider);
    final AsyncValue<List<OrdersResponse>> orders = ref.watch(ordersProvider);

    final data = calculateTotalByWeek(
      filterOrdersByWeek(
        orders.when(
          data: (orders) => orders,
          error: (err, stack) => [],
          loading: () => [],
        ),
        selectedWeek,
      ),
      selectedWeek,
    );

    return orders.when(
      data: (orders) => resumeCard(context, bcvValue, data, orders),
      error: (err, stack) => Text('Error: $err'),
      loading: () => const CircularProgressIndicator(),
    );
  }

  Padding resumeCard(
    BuildContext context,
    AsyncValue<double> bcvValue,
    TotalOrdersByDay data,
    List<OrdersResponse> orders,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, top: 8, bottom: 8),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrdersWeekScreen(
              selectedWeek: selectedWeek,
              bcvValue: bcvValue.value!,
              futureOrders: futureOrders,
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: const Color.fromARGB(255, 0, 0, 0),
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
                        borderRadius: BorderRadius.circular(5.0),
                        color: const Color.fromARGB(255, 87, 66, 47),
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
                              "${formatter(data.date)} / ${data.date.add(Duration(days: 4)).day} ",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      spacing: 3,
                      children: [
                        Row(
                          children: [
                            bcvValue.when(
                              data: (bcv) => relacionDolarBs(
                                data,
                                bcv,
                                Colors.green,
                                preciosVenta,
                              ),
                              error: (err, stack) => Text('Error: $err'),
                              loading: () => const CircularProgressIndicator(),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            bcvValue.when(
                              data: (bcv) => relacionDolarBs(
                                data,
                                bcv,
                                Colors.red,
                                preciosCorigas,
                              ),
                              error: (err, stack) => Text('Error: $err'),
                              loading: () => const CircularProgressIndicator(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  spacing: 10,
                  children: [
                    Row(
                      children: [
                        cantCilindros("10kg", data.cant10, preciosVenta[0]),
                      ],
                    ),
                    Row(
                      children: [
                        cantCilindros("18kg", data.cant18, preciosVenta[1]),
                      ],
                    ),
                    Row(
                      children: [
                        cantCilindros("21kg", data.cant21, preciosVenta[2]),
                      ],
                    ),
                    Row(
                      children: [
                        cantCilindros("27kg", data.cant27, preciosVenta[3]),
                      ],
                    ),
                    Row(
                      children: [
                        cantCilindros("43kg", data.cant43, preciosVenta[4]),
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
