import 'package:bombonas_app/data/models/bcv_response.dart';
import 'package:bombonas_app/data/models/clients_response.dart';
import 'package:bombonas_app/data/models/form_post.dart';
import 'package:bombonas_app/data/models/orders_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Repository {
  String baseUrl = "https://api.gas.jodomodev.com";

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

  Future<BcvResponse> fetchBcv() async {
    final response = await http.get(
      Uri.parse("https://ve.dolarapi.com/v1/dolares"),
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body)[0];
      BcvResponse bcvResponse = BcvResponse.fromJson(json);
      return bcvResponse;
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

  Future<bool> deleteOrder(int orderId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/orders/delete/$orderId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('fallo al cargar');
    }
  }

  Future<http.Response> updatePaidOrder(int id, bool paid) async {
    String url = paid
        ? "$baseUrl/orders/notpaid/$id"
        : "$baseUrl/orders/paid/$id";
    return await http.patch(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }
}
