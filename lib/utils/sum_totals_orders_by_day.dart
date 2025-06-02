import 'package:bombonas_app/data/models/orders_response.dart';
import 'package:bombonas_app/utils/same_day.dart';

class TotalOrdersByDay {
  DateTime date;
  int cant10;
  int cant18;
  int cant21;
  int cant27;
  int cant43;

  TotalOrdersByDay({
    required this.date,
    required this.cant10,
    required this.cant18,
    required this.cant21,
    required this.cant27,
    required this.cant43,
  });
}

TotalOrdersByDay calculateTotalByDay(
  List<OrdersResponse> orders,
  DateTime date,
) {
  List<OrdersResponse> filteredOrders = orders
      .where((order) => sameDay(date, DateTime.parse(order.date)))
      .toList();

  int cant10 = 0;
  int cant18 = 0;
  int cant21 = 0;
  int cant27 = 0;
  int cant43 = 0;

  for (var order in filteredOrders) {
    cant10 += order.orderDetail.kg10;
    cant18 += order.orderDetail.kg18;
    cant21 += order.orderDetail.kg21;
    cant27 += order.orderDetail.kg27;
    cant43 += order.orderDetail.kg43;
  }

  return TotalOrdersByDay(
    date: date,
    cant10: cant10,
    cant18: cant18,
    cant21: cant21,
    cant27: cant27,
    cant43: cant43,
  );
}

TotalOrdersByDay calculateTotalByWeek(
  List<OrdersResponse> orders,
  DateTime date,
) {
  int cant10 = 0;
  int cant18 = 0;
  int cant21 = 0;
  int cant27 = 0;
  int cant43 = 0;

  for (var order in orders) {
    cant10 += order.orderDetail.kg10;
    cant18 += order.orderDetail.kg18;
    cant21 += order.orderDetail.kg21;
    cant27 += order.orderDetail.kg27;
    cant43 += order.orderDetail.kg43;
  }

  return TotalOrdersByDay(
    date: date,
    cant10: cant10,
    cant18: cant18,
    cant21: cant21,
    cant27: cant27,
    cant43: cant43,
  );
}

List<OrdersResponse> filterOrdersByWeek(
  List<OrdersResponse> orders,
  DateTime? selectedWeek,
) {
  var ordenesFiltradas = orders.where((order) {
    List<DateTime?> fechasValidas = [
      selectedWeek,
      selectedWeek?.add(Duration(days: 1)),
      selectedWeek?.add(Duration(days: 2)),
      selectedWeek?.add(Duration(days: 3)),
      selectedWeek?.add(Duration(days: 4)),
    ];

    bool isValid = fechasValidas.any(
      (fechaValida) => sameDay(fechaValida, DateTime.parse(order.date)),
    );

    return isValid;
  }).toList();

  return ordenesFiltradas;
}
