import 'package:bombonas_app/components/app_bar.dart';
import 'package:bombonas_app/screens/create_order_screen.dart';
import 'package:bombonas_app/components/date_bar.dart';
import 'package:bombonas_app/components/order_card.dart';
import 'package:bombonas_app/data/models/orders_response.dart';
import 'package:bombonas_app/data/repository.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // Future<List<OrdersResponse>>? _orders;
  Repository repository = Repository();
  Future<List<OrdersResponse>>? _orders;

  @override
  void initState() {
    super.initState();
    _fetchOrders(); // Carga las órdenes cuando la pantalla se inicia
  }

  Future<void> _fetchOrders() async {
    setState(() {
      _orders = null; // Limpia la lista mientras se recarga
    });
    // Simula una llamada a la API para obtener las órdenes
    setState(() {
      _orders = repository.fetchOrders();
    });
  }

  // Future<List<OrdersResponse>> fet = Repository().fetchOrders();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 39, 39, 39),
      appBar: appBarComponent("Ordenes"),
      body: Column(children: [dateBar(), ordersList(_orders)]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () async {
          final bool? orderAdded = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateOrderScreen()),
          );

          if (orderAdded == true) {
            print('Una nueva orden fue agregada, recargando la lista.');
            // Llama a la función para recargar tus órdenes
            _fetchOrders(); // Tu método para obtener las órdenes actualizadas
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
