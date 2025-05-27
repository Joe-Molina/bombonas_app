import 'package:bombonas_app/data/models/clients_response.dart';
import 'package:bombonas_app/data/models/orders_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Repository {
  Future<List<OrdersResponse>> fetchOrders() async {
    final response = await http.get(
      Uri.parse("http://10.10.1.253:3000/orders/get/all"),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);

      return OrdersResponse.fromJsonList(jsonList);
    } else {
      throw Exception('fallo al cargar');
    }
  }

  Future<List<ClientsResponse>> fetchClients() async {
    final response = await http.get(
      Uri.parse("http://10.10.1.253:3000/clients/get/all"),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);

      return ClientsResponse.fromJsonList(jsonList);
    } else {
      throw Exception('fallo al cargar');
    }
  }
}
