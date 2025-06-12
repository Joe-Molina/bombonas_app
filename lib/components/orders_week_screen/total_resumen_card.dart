import 'package:bombonas_app/components/order_card.dart';
import 'package:bombonas_app/data/models/orders_response.dart';
import 'package:bombonas_app/screens/day_orders_screen.dart';
import 'package:bombonas_app/utils/same_day.dart';
import 'package:bombonas_app/utils/sum_totals_orders_by_day.dart';
import 'package:flutter/material.dart';

Padding totalResumenCard(
  BuildContext context,
  TotalOrdersByDay data,
  double bcv,
  Future<List<OrdersResponse>>? futureOrders,
) {
  return Padding(
    padding: const EdgeInsets.only(left: 4, right: 4, top: 1, bottom: 1),
    child: GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrdersDayScreen(
            futureOrders: futureOrders,
            bcvValue: bcv,
            orders: data,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: const Color.fromARGB(104, 0, 0, 0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 3,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      // border: Border.all(color: Colors.white, width: .5)
                      borderRadius: BorderRadius.circular(3.0),
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
                          Text(
                            formatter(data.date),
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 2,
                        top: 2,
                        left: 8,
                        right: 8,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.arrow_circle_down, color: Colors.green),
                          Text(
                            " ${((data.cant10 * 5.5) + (data.cant18 * 11) + (data.cant21 * 13) + (data.cant27 * 16) + (data.cant43 * 24))}\$ / ${(((data.cant10 * 5.5) + (data.cant18 * 11) + (data.cant21 * 13) + (data.cant27 * 16) + (data.cant43 * 24)) * bcv).toStringAsFixed(2)} Bs.",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 2,
                        top: 2,
                        left: 8,
                        right: 8,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.arrow_circle_up, color: Colors.red),
                          Text(
                            " ${((data.cant10 * 4) + (data.cant18 * 10) + (data.cant21 * 12) + (data.cant27 * 12) + (data.cant43 * 20))}\$ / ${(((data.cant10 * 4) + (data.cant18 * 10) + (data.cant21 * 12) + (data.cant27 * 12) + (data.cant43 * 20)) * bcv).toStringAsFixed(2)} Bs.",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
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
