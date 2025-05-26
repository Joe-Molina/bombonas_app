class OrdersResponse {
  final String id;
  final DateTime date;
  final String clientId;

  OrdersResponse({
    required this.id,
    required this.date,
    required this.clientId,
  });

  factory OrdersResponse.fromJson(Map<String, dynamic> json) {
    return OrdersResponse(
      id: json["id"],
      date: json["date"],
      clientId: json["clientId"],
    );
  }

  static List<OrdersResponse> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => OrdersResponse.fromJson(json)).toList();
  }
}
