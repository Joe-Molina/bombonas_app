import 'package:bombonas_app/data/models/orders_detail_response.dart';
import 'package:bombonas_app/utils/sum_totals_orders_by_day.dart';
import 'package:flutter/material.dart';

Container relacionDolarBs(
  dynamic cant,
  double bcv,
  Color iconColor,
  List<double> prices,
) {
  double totalInDolars() {
    if (cant is TotalOrdersByDay) {
      return ((cant.cant10 * prices[0]) +
          (cant.cant18 * prices[1]) +
          (cant.cant21 * prices[2]) +
          (cant.cant27 * prices[3]) +
          (cant.cant43 * prices[4]));
    } else if (cant is OrdersDetailResponse) {
      return ((cant.kg10 * prices[0]) +
          (cant.kg18 * prices[1]) +
          (cant.kg21 * prices[2]) +
          (cant.kg27 * prices[3]) +
          (cant.kg43 * prices[4]));
    } else {
      return 0;
    }
  }

  return Container(
    decoration: BoxDecoration(
      color: Colors.grey[900],
      borderRadius: BorderRadius.all(Radius.circular(5)),
    ),
    child: Padding(
      padding: const EdgeInsets.only(bottom: 2, top: 2, left: 8, right: 8),
      child: Row(
        children: [
          Icon(
            iconColor == Colors.green
                ? Icons.arrow_circle_up
                : Icons.arrow_circle_down,
            color: iconColor,
          ),
          Text(
            "${totalInDolars()}\$ / ${(totalInDolars() * bcv).toStringAsFixed(2)} Bs.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}
