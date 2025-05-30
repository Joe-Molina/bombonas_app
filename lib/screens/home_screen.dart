import 'package:bombonas_app/components/home_screen/select_week.dart';
import 'package:bombonas_app/data/models/orders_response.dart';
import 'package:bombonas_app/data/repository.dart';
import 'package:bombonas_app/utils/last_four_weeks.dart';
import 'package:flutter/material.dart';

class HomerScreen extends StatefulWidget {
  const HomerScreen({super.key});

  @override
  State<HomerScreen> createState() => _HomerScreenState();
}

class _HomerScreenState extends State<HomerScreen> {
  Future<List<OrdersResponse>>? _futureOrders;
  List<OrdersResponse> _allOrders = [];

  void loadData() {
    _futureOrders = Repository().fetchOrders();

    _futureOrders!
        .then(
          (orders) => {
            setState(() {
              _allOrders = orders;
              // Actualizar la lista de órdenes al cargar
              print(_allOrders);
            }),
          },
        )
        .catchError(
          (error) => {
            if (mounted)
              {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error al cargar las órdenes: $error'),
                  ),
                ),
              },
          },
        );
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 39, 39, 39),
      appBar: AppBar(
        title: Text('Ultimas Cuatro Semanas'),
        backgroundColor: Color.fromARGB(255, 30, 30, 30),
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.all(16.0), child: SelectWeek()),
          Container(padding: EdgeInsets.all(16.0), child: Text("a")),
        ],
      ),
    );
  }
}
