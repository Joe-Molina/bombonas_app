import 'package:bombonas_app/components/orders_week_screen/select_week.dart';
import 'package:bombonas_app/components/resume_week_card.dart';
import 'package:bombonas_app/data/models/clients_response.dart';
import 'package:bombonas_app/data/models/orders_response.dart';
import 'package:bombonas_app/data/repository.dart';
import 'package:bombonas_app/screens/create_order_screen.dart';
import 'package:bombonas_app/utils/last_four_weeks.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedWeek = getLastFourWeeksDays().last;
  List<ClientsResponse> _allClients = [];

  Future<List<OrdersResponse>>? _futureOrders;
  List<OrdersResponse> _allOrders = [];

  void _setSelectedWeek(newOrders) {
    setState(() {
      _selectedWeek = newOrders;
    });
  }

  void loadData() async {
    _futureOrders = Repository().fetchOrders();

    _futureOrders!
        .then(
          (orders) => {
            setState(() {
              _allOrders = orders;
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

    setState(() {
      Future<List<ClientsResponse>> clientsRespose = Repository()
          .fetchClients();
      clientsRespose.then((clients) => {_allClients = clients});
    });
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
        title: Text('Home Screen'),
        backgroundColor: Color.fromARGB(255, 30, 30, 30),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4, right: 4, top: 12, bottom: 8),
            child: SelectWeek(
              orders: _allOrders,
              setSelectedWeek: _setSelectedWeek,
              selectedWeek: _selectedWeek,
            ),
          ),
          ResumeCardWeek(
            context: context,
            selectedWeek: _selectedWeek,
            futureOrders: _futureOrders,
          ),
        ],
      ),
      floatingActionButton: btnCrearOrden(context),
    );
  }

  FloatingActionButton btnCrearOrden(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.black,
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateOrderScreen(clients: _allClients),
          ),
        );

        if (result is bool) {
          loadData();
        }
      },
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
