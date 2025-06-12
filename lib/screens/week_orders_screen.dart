import 'package:bombonas_app/components/app_bar.dart';
import 'package:bombonas_app/components/resume_week_card.dart';
import 'package:bombonas_app/components/orders_week_screen/total_resumen_card.dart';
import 'package:bombonas_app/data/models/orders_response.dart';
import 'package:bombonas_app/utils/same_day.dart';
import 'package:bombonas_app/utils/sum_totals_orders_by_day.dart';
import 'package:flutter/material.dart';

class OrdersWeekScreen extends StatefulWidget {
  final DateTime selectedWeek;
  final double bcvValue;
  final Future<List<OrdersResponse>>? futureOrders;
  final List<OrdersResponse> allOrders;
  const OrdersWeekScreen({
    super.key,
    required this.selectedWeek,
    required this.allOrders,
    required this.bcvValue,
    this.futureOrders,
  });

  @override
  State<OrdersWeekScreen> createState() => _OrdersWeekState();
}

class _OrdersWeekState extends State<OrdersWeekScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 39, 39, 39),
      appBar: appBarComponent(
        "Ordenes semana ${formatter(widget.selectedWeek)} / ${widget.selectedWeek.add(Duration(days: 4)).day}",
      ),
      body: Column(
        children: [
          totalOrdersList(
            widget.futureOrders,
            filterOrdersByWeek(widget.allOrders, widget.selectedWeek),
            widget.bcvValue,
          ),
        ],
      ),
    );
  }

  FutureBuilder<List<OrdersResponse>> totalOrdersList(
    ordenes,
    ordenesCargadas,
    double bcv,
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
          // var ordersList = snapshot.data;
          return Expanded(
            child: Column(
              children: [
                ResumeCardWeekWithoutNavegation(
                  context: context,
                  data: calculateTotalByWeek(
                    ordenesCargadas,
                    widget.selectedWeek,
                  ),
                  bcv: widget.bcvValue,
                  selectedWeek: widget.selectedWeek,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      if (ordenesCargadas != null) {
                        return totalResumenCard(
                          context,
                          calculateTotalByDay(
                            ordenesCargadas,
                            widget.selectedWeek.add(Duration(days: index)),
                          ),
                          bcv,
                          widget.futureOrders,
                        );
                      } else {
                        return Text("Error");
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return Text("no hay resultados");
        }
      },
    );
  }
}
