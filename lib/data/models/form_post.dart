class OrdersDetailForm {
  final int kg10;
  final int kg18;
  final int kg21;
  final int kg27;
  final int kg43;

  OrdersDetailForm({
    required this.kg10,
    required this.kg18,
    required this.kg21,
    required this.kg27,
    required this.kg43,
  });

  Map<String, dynamic> toJson() {
    return {
      'kg10': kg10, // Usa el toJson() del detalle
      'kg18': kg18,
      'kg21': kg21,
      'kg27': kg27,
      'kg43': kg43,
    };
  }
}

class FormOrder {
  final int clientId;
  final DateTime date;
  final OrdersDetailForm orderDetail;

  FormOrder({
    required this.clientId,
    required this.date,
    required this.orderDetail,
  });

  Map<String, dynamic> toJson() {
    return {
      'clientId': clientId,
      'date': date
          .toUtc()
          .toIso8601String(), // Si es DateTime: date.toIso8601String()
      'OrderDetail': orderDetail.toJson(), // Usa el toJson() del detalle
    };
  }
}
