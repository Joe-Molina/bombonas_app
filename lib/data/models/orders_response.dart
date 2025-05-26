import 'package:bombonas_app/data/models/orders_detail_response.dart';

class OrdersResponse {
  final int id;
  final String date;
  final int clientId;
  final ClientResponse client;
  final OrdersDetailResponse orderDetail;

  OrdersResponse({
    required this.id,
    required this.date,
    required this.clientId,
    required this.client,
    required this.orderDetail,
  });

  factory OrdersResponse.fromJson(Map<String, dynamic> json) {
    return OrdersResponse(
      id: json["id"],
      date: json["date"],
      clientId: json["clientId"],
      client: ClientResponse.fromJson(json["client"]),
      orderDetail: OrdersDetailResponse.fromJson(json["orderDetail"][0]),
    );
  }

  static List<OrdersResponse> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => OrdersResponse.fromJson(json)).toList();
  }
}
