import 'package:bombonas_app/components/app_bar.dart';
import 'package:bombonas_app/data/models/clients_response.dart';
import 'package:bombonas_app/screens/create_order_screen.dart';
import 'package:bombonas_app/components/order_card.dart';
import 'package:bombonas_app/data/models/orders_response.dart';
import 'package:bombonas_app/screens/order_detail.dart';
import 'package:bombonas_app/utils/same_day.dart';
import 'package:bombonas_app/utils/sum_totals_orders_by_day.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  final Future<List<OrdersResponse>>? futureOrders;
  final TotalOrdersByDay orders;
  final List<ClientsResponse> clients;
  // final DateTime selectedWeek;
  final double bcvValue;
  const OrdersScreen({
    super.key,
    required this.bcvValue,
    // required this.selectedWeek,
    required this.futureOrders,
    required this.orders,
    required this.clients,
  });

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 39, 39, 39),
      appBar: appBarComponent("Ordenes"),
      body: Column(
        children: [
          ResumeCard(
            data: widget.orders,
            bcv: widget.bcvValue,
            context: context,
          ),
          ordersList(widget.futureOrders, widget.orders, widget.bcvValue),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateOrderScreen(clients: widget.clients),
            ),
          );

          if (result is bool) {
            // _loadOrders(); cambiar por el método que recargue los datos o sea un setState
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class ResumeCard extends StatelessWidget {
  const ResumeCard({
    super.key,
    required this.data,
    required this.bcv,
    required this.context,
  });

  final TotalOrdersByDay data;
  final double bcv;
  final dynamic context;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
    child: GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrderDetailScreen()),
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
                      borderRadius: BorderRadius.circular(10.0),
                      color: const Color.fromARGB(255, 87, 47, 47),
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
                          Text("Total:", style: TextStyle(color: Colors.white)),
                          Text(
                            formatter(data.date),
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Recibido: ${((data.cant10 * 5.5) + (data.cant18 * 11) + (data.cant21 * 13) + (data.cant27 * 16) + (data.cant43 * 24))}\$ / ${(((data.cant10 * 5.5) + (data.cant18 * 11) + (data.cant21 * 13) + (data.cant27 * 16) + (data.cant43 * 24)) * bcv).toStringAsFixed(2)} Bs.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Pagado: ${((data.cant10 * 5) + (data.cant18 * 10) + (data.cant21 * 12) + (data.cant27 * 15) + (data.cant43 * 22))}\$ / ${(((data.cant10 * 5) + (data.cant18 * 10) + (data.cant21 * 12) + (data.cant27 * 15) + (data.cant43 * 22)) * bcv).toStringAsFixed(2)} Bs.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                spacing: 10,
                children: [
                  Row(children: [cantCilindros("10kg", data.cant10, 5.5)]),
                  Row(children: [cantCilindros("18kg", data.cant18, 11)]),
                  Row(children: [cantCilindros("21kg", data.cant21, 13)]),
                  Row(children: [cantCilindros("27kg", data.cant27, 16)]),
                  Row(children: [cantCilindros("43kg", data.cant43, 24)]),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
