import 'package:bombonas_app/components/app_bar.dart';
import 'package:bombonas_app/components/order_card.dart';
import 'package:bombonas_app/components/relacion_dolar_boilvares_in_card.dart';
import 'package:bombonas_app/data/models/orders_response.dart';
import 'package:bombonas_app/screens/home_screen.dart';
import 'package:bombonas_app/utils/precios.dart';
import 'package:bombonas_app/utils/same_day.dart';
import 'package:bombonas_app/utils/sum_totals_orders_by_day.dart';
import 'package:flutter/material.dart';

class OrdersDayScreen extends StatefulWidget {
  final Future<List<OrdersResponse>>? futureOrders;
  final TotalOrdersByDay orders;
  final double bcvValue;
  const OrdersDayScreen({
    super.key,
    required this.bcvValue,
    required this.futureOrders,
    required this.orders,
  });

  @override
  State<OrdersDayScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersDayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 39, 39, 39),
      appBar: appBarComponent("Ordenes ${formatter(widget.orders.date)}"),
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
    padding: const EdgeInsets.only(left: 4, right: 4, top: 8, bottom: 1),
    child: GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
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
                    spacing: 3,
                    children: [
                      relacionDolarBs(data, bcv, Colors.green, preciosVenta),
                      relacionDolarBs(data, bcv, Colors.red, preciosCorigas),
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
