import 'package:bombonas_app/components/app_bar.dart';
import 'package:bombonas_app/components/resume_week_card.dart';
import 'package:bombonas_app/components/orders_week_screen/total_resumen_card.dart';
import 'package:bombonas_app/data/models/orders_response.dart';
import 'package:bombonas_app/presentation/providers/providers.dart';
import 'package:bombonas_app/utils/same_day.dart';
import 'package:bombonas_app/utils/sum_totals_orders_by_day.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrdersWeekScreen extends ConsumerStatefulWidget {
  final DateTime selectedWeek;
  final double bcvValue;
  final Future<List<OrdersResponse>>? futureOrders;
  const OrdersWeekScreen({
    super.key,
    required this.selectedWeek,
    required this.bcvValue,
    this.futureOrders,
  });

  @override
  ConsumerState<OrdersWeekScreen> createState() => _OrdersWeekState();
}

class _OrdersWeekState extends ConsumerState<OrdersWeekScreen> {
  @override
  Widget build(BuildContext context) {
    return ref
        .watch(ordersProvider)
        .when(
          data: (orders) {
            return Scaffold(
              backgroundColor: Color.fromARGB(255, 39, 39, 39),
              appBar: appBarComponent(
                "Ordenes semana ${formatter(widget.selectedWeek)} / ${widget.selectedWeek.add(Duration(days: 4)).day}",
              ),
              body: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        ResumeCardWeek(
                          context: context,
                          selectedWeek: widget.selectedWeek,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return totalResumenCard(
                                context,
                                calculateTotalByDay(
                                  orders,
                                  widget.selectedWeek.add(
                                    Duration(days: index),
                                  ),
                                ),
                                widget.bcvValue,
                                widget.futureOrders,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          error: (err, stack) => Text('Error: $err'),
          loading: () => const CircularProgressIndicator(),
        );
  }
}
