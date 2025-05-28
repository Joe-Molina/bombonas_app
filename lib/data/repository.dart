import 'package:bombonas_app/data/models/clients_response.dart';
import 'package:bombonas_app/data/models/form_post.dart';
import 'package:bombonas_app/data/models/orders_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Repository {
  String baseUrl = "https://api-cilindros.onrender.com";

  Future<List<OrdersResponse>> fetchOrders() async {
    final response = await http.get(Uri.parse("$baseUrl/orders/get/all"));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);

      return OrdersResponse.fromJsonList(jsonList);
    } else {
      throw Exception('fallo al cargar');
    }
  }

  Future<List<ClientsResponse>> fetchClients() async {
    final response = await http.get(Uri.parse("$baseUrl/clients/get/all"));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);

      return ClientsResponse.fromJsonList(jsonList);
    } else {
      throw Exception('fallo al cargar');
    }
  }

  Future<http.Response> createOrder(FormOrder order) async {
    return await http.post(
      Uri.parse('$baseUrl/orders/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        order.toJson(),
      ), // Asegúrate de tener toJson() en FormOrder
    );
  }
}
