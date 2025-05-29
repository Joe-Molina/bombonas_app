import 'package:bombonas_app/components/app_bar.dart';
import 'package:bombonas_app/data/models/bcv_response.dart';
import 'package:bombonas_app/data/models/clients_response.dart';
import 'package:bombonas_app/data/models/form_post.dart';
import 'package:bombonas_app/screens/create_order_screen.dart';
import 'package:bombonas_app/components/order_card.dart';
import 'package:bombonas_app/data/models/orders_response.dart';
import 'package:bombonas_app/data/repository.dart';
import 'package:bombonas_app/screens/order_detail.dart';
import 'package:bombonas_app/styles/input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Repository repository = Repository();

  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();

  Future<List<OrdersResponse>>? _futureOrders;
  List<OrdersResponse> _allOrders = [];
  List<OrdersResponse> _filteredOrders = [];

  Future<List<ClientsResponse>>? _futureClients;
  List<ClientsResponse> _allClients = [];

  BcvResponse? _bcvValue; // Usa un tipo nullable porque al inicio no hay valor
  bool _isLoading = true;
  String _error = '';

  OrdersDetailForm get _orderDetails =>
      getOrderDetails(_filteredOrders); // Obtiene los detalles de las órdenes

  Future<BcvResponse> fetchBcv() async {
    // Simula una llamada a la API
    return await Repository().fetchBcv();
    // Simula la respuesta real
  }

  @override
  void initState() {
    super.initState();
    // _fetchOrders(); // Carga las órdenes cuando la pantalla se inicia
    _loadOrders();
    _loadBcv();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 39, 39, 39),
      appBar: appBarComponent("Ordenes"),
      body: Column(
        children: [
          dateBar(),
          ResumeCard(
            total: _orderDetails,
            bcv: _bcvValue!.price,
            context: context,
          ),
          ordersList(_futureOrders, _filteredOrders, (_bcvValue?.price)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateOrderScreen(clients: _allClients),
            ),
          );

          if (result is bool) {
            _loadOrders();
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Padding dateBar() => Padding(
    padding: const EdgeInsets.all(16.0),
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 20, 20, 20),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Text(
            //   DateFormat('dd/MM/yy').format(DateTime.now()),
            //   style: TextStyle(fontSize: 20, color: Colors.white),
            // ),
            Expanded(child: datePicker(context)),
          ],
        ),
      ),
    ),
  );

  TextFormField datePicker(BuildContext context) {
    return TextFormField(
      controller: _dateController,
      readOnly: true, // Hace que el campo no sea editable directamente
      onTap: () => _selectDate(context), // Abre el selector de fecha al tocar
      style: const TextStyle(color: Colors.white),
      decoration: inputStyle("Buscar Ordenes por fecha"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, selecciona una fecha.';
        }
        return null;
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedDate ?? DateTime.now(), // Fecha inicial al abrir el picker
      firstDate: DateTime(2000), // Fecha mínima permitida
      lastDate: DateTime(2101), // Fecha máxima permitida
      helpText: 'Selecciona una fecha', // Título en el picker
      cancelText: 'Cancelar',
      confirmText: 'Confirmar',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue, // Color del header del picker y botones
              onPrimary: Colors.white, // Color del texto en el header
              onSurface: Colors.black, // Color del texto del calendario
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    Colors.blue, // Color de los botones "Cancelar" y "Aceptar"
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // Formatear la fecha para mostrarla en el TextFormField
        _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
      });

      _applyFilter();
    }
  }

  void _applyFilter() {
    if (_selectedDate != null) {
      setState(() {
        _filteredOrders = _allOrders
            .where(
              (order) =>
                  areDatesOnSameDay(DateTime.parse(order.date), _selectedDate!),
            )
            .toList(); // Aplica el filtro
      });
    } else {
      _filteredOrders = _allOrders;
    }
  }

  void _loadOrders() {
    setState(() {
      _futureOrders = repository
          .fetchOrders(); // Asigna el Future a la variable

      _futureClients = repository.fetchClients();
    });

    _futureOrders!
        .then((orders) {
          // Cuando el Future se resuelve (los datos llegan):
          setState(() {
            _allOrders = orders; // Almacena la lista completa
            _applyFilter(); // Aplica el filtro inicial o por defecto
          });
        })
        .catchError((error) {
          // Manejo de errores
          // print("Error al cargar órdenes: $error");
          // Opcional: mostrar un mensaje de error en la UI
        });

    _futureClients!
        .then((clients) {
          // Cuando el Future se resuelve (los datos llegan):
          setState(() {
            _allClients = clients; // Almacena la lista completa
          });
        })
        .catchError((error) {
          // Manejo de errores
          // print("Error al cargar órdenes: $error");
          // Opcional: mostrar un mensaje de error en la UI
        });
  }

  void _loadBcv() async {
    // <-- Esta función debe ser async
    setState(() {
      _isLoading = true;
      _error = '';
    });
    try {
      final response = await fetchBcv(); // <-- Aquí esperas el Future
      setState(() {
        _bcvValue = response; // Asigna el valor real a la variable de estado
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar BCV: $e';
        _isLoading = false;
      });
    }
  }
}

class ResumeCard extends StatelessWidget {
  const ResumeCard({
    super.key,
    required this.total,
    required this.bcv,
    required this.context,
  });

  final OrdersDetailForm total;
  final double bcv;
  final dynamic context;

  @override
  Widget build(BuildContext context) => Padding(
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
                      borderRadius: BorderRadius.circular(10.0),
                      color: const Color.fromARGB(255, 87, 47, 47),
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
                          Text("Total:", style: TextStyle(color: Colors.white)),
                          Text(
                            DateFormat('dd/MM/yy').format(DateTime.now()),
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Recibido: ${((total.kg10 * 5.5) + (total.kg18 * 11) + (total.kg21 * 13) + (total.kg27 * 16) + (total.kg43 * 24))}\$ / ${(((total.kg10 * 5.5) + (total.kg18 * 11) + (total.kg21 * 13) + (total.kg27 * 16) + (total.kg43 * 24)) * bcv).toStringAsFixed(2)} Bs.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Pagar: ${((total.kg10 * 5) + (total.kg18 * 10) + (total.kg21 * 12) + (total.kg27 * 15) + (total.kg43 * 22))}\$ / ${(((total.kg10 * 5) + (total.kg18 * 10) + (total.kg21 * 12) + (total.kg27 * 15) + (total.kg43 * 22)) * bcv).toStringAsFixed(2)} Bs.",
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
                  Row(children: [cantCilindros("10kg", total.kg10, 5.5)]),
                  Row(children: [cantCilindros("18kg", total.kg18, 11)]),
                  Row(children: [cantCilindros("21kg", total.kg21, 13)]),
                  Row(children: [cantCilindros("27kg", total.kg27, 16)]),
                  Row(children: [cantCilindros("43kg", total.kg43, 24)]),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

bool areDatesOnSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

OrdersDetailForm getOrderDetails(List<OrdersResponse> orders) {
  int kg10 = 0;
  int kg18 = 0;
  int kg21 = 0;
  int kg27 = 0;
  int kg43 = 0;

  for (var order in orders) {
    kg10 += order.orderDetail.kg10;
    kg18 += order.orderDetail.kg18;
    kg21 += order.orderDetail.kg21;
    kg27 += order.orderDetail.kg27;
    kg43 += order.orderDetail.kg43;
  }

  return OrdersDetailForm(
    kg10: kg10,
    kg18: kg18,
    kg21: kg21,
    kg27: kg27,
    kg43: kg43,
  );
}

// arreglar hora en total week a la hora q esta en el estado escogida
