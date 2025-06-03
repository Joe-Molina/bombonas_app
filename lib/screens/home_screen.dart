import 'package:bombonas_app/components/home_screen/select_week.dart';
import 'package:bombonas_app/components/home_screen/total_resumen_card.dart';
import 'package:bombonas_app/components/order_card.dart';
import 'package:bombonas_app/data/models/bcv_response.dart';
import 'package:bombonas_app/data/models/clients_response.dart';
import 'package:bombonas_app/data/models/orders_response.dart';
import 'package:bombonas_app/data/repository.dart';
import 'package:bombonas_app/screens/order_detail.dart';
import 'package:bombonas_app/utils/last_four_weeks.dart';
import 'package:bombonas_app/utils/same_day.dart';
import 'package:bombonas_app/utils/sum_totals_orders_by_day.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedWeek = getLastFourWeeksDays().first;
  BcvResponse? _bcvValue;
  Future<List<OrdersResponse>>? _futureOrders;
  List<OrdersResponse> _allOrders = [];
  List<ClientsResponse> _allClients = [];

  void _setSelectedWeek(newOrders) {
    setState(() {
      _selectedWeek = newOrders;
    });
  }

  void loadData() async {
    _futureOrders = Repository().fetchOrders();

    BcvResponse bcv = await Repository().fetchBcv();

    setState(() {
      _bcvValue = bcv;
    });

    setState(() {
      Future<List<ClientsResponse>> clientsRespose = Repository()
          .fetchClients();
      clientsRespose.then((clients) => {_allClients = clients});
    });

    _futureOrders!
        .then(
          (orders) => {
            setState(() {
              _allOrders = orders;
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
          Padding(
            padding: EdgeInsets.all(16.0),
            child: SelectWeek(
              orders: _allOrders,
              setSelectedWeek: _setSelectedWeek,
              selectedWeek: _selectedWeek,
            ),
          ),
          totalOrdersList(
            _futureOrders,
            filterOrdersByWeek(_allOrders, _selectedWeek),
            _bcvValue?.price,
          ),
        ],
      ),
    );
  }

  Padding resumenCardWeek(
    BuildContext context,
    TotalOrdersByDay data,
    double? bcv,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrderDetailScreen()),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        // border: Border.all(color: Colors.white, width: .5)
                        borderRadius: BorderRadius.circular(5.0),
                        color: const Color.fromARGB(255, 87, 66, 47),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 2,
                          bottom: 2,
                          left: 12,
                          right: 12,
                        ),
                        child: Row(
                          spacing: 10,
                          children: [
                            Text(
                              "${formatter(data.date)} / ${formatter(data.date.add(Duration(days: 4)))} ",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Recibido: ${((data.cant10 * 5.5) + (data.cant18 * 11) + (data.cant21 * 13) + (data.cant27 * 16) + (data.cant43 * 24))}\$ / ${(((data.cant10 * 5.5) + (data.cant18 * 11) + (data.cant21 * 13) + (data.cant27 * 16) + (data.cant43 * 24)) * bcv!).toStringAsFixed(2)} Bs.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Pagado: ${((data.cant10 * 5) + (data.cant18 * 10) + (data.cant21 * 12) + (data.cant27 * 15) + (data.cant43 * 22))}\$ / ${(((data.cant10 * 5) + (data.cant18 * 10) + (data.cant21 * 12) + (data.cant27 * 15) + (data.cant43 * 22)) * bcv!).toStringAsFixed(2)} Bs.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  spacing: 10,
                  children: [
                    Row(children: [cantCilindros("10kg", data.cant10, 5.5)]),
                    Row(children: [cantCilindros("18kg", data.cant18, 11)]),
                    Row(children: [cantCilindros("21kg", data.cant21, 13)]),
                    Row(children: [cantCilindros("27kg", data.cant27, 16)]),
                    Row(children: [cantCilindros("43kg", data.cant43, 24)]),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FutureBuilder<List<OrdersResponse>> totalOrdersList(
    ordenes,
    ordenesCargadas,
    double? bcv,
  ) {
    return FutureBuilder(
      future: ordenes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text(
            "Error: ${snapshot.error}",
            style: TextStyle(color: Colors.white),
          );
        } else if (snapshot.hasData) {
          // var ordersList = snapshot.data;
          return Expanded(
            child: Column(
              children: [
                resumenCardWeek(
                  context,
                  calculateTotalByWeek(ordenesCargadas, _selectedWeek),
                  _bcvValue?.price,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      if (ordenesCargadas != null) {
                        return totalResumenCard(
                          context,
                          calculateTotalByDay(
                            ordenesCargadas,
                            _selectedWeek.add(Duration(days: index)),
                          ),
                          bcv,
                          _allClients,
                          _futureOrders,
                        );
                      } else {
                        return Text("Error");
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return Text("no hay resultados");
        }
      },
    );
  }
}
