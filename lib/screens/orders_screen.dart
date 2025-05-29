import 'package:bombonas_app/components/app_bar.dart';
import 'package:bombonas_app/screens/create_order_screen.dart';
import 'package:bombonas_app/components/order_card.dart';
import 'package:bombonas_app/data/models/orders_response.dart';
import 'package:bombonas_app/data/repository.dart';
import 'package:bombonas_app/styles/input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // Future<List<OrdersResponse>>? _orders;
  Repository repository = Repository();
  // Future<List<OrdersResponse>>? _orders;
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();
  Future<List<OrdersResponse>>? _futureOrders;
  List<OrdersResponse> _allOrders = [];
  List<OrdersResponse> _filteredOrders = [];

  @override
  void initState() {
    super.initState();
    // _fetchOrders(); // Carga las órdenes cuando la pantalla se inicia
    _loadOrders();
  }

  // Future<void> _fetchOrders() async {
  //   setState(() {
  //     _futureOrders = null; // Limpia la lista mientras se recarga
  //   });
  //   // Simula una llamada a la API para obtener las órdenes
  //   setState(() {
  //     _futureOrders = repository.fetchOrders();
  //   });
  // }

  // Future<List<OrdersResponse>> fet = Repository().fetchOrders();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 39, 39, 39),
      appBar: appBarComponent("Ordenes"),
      body: Column(
        children: [dateBar(), ordersList(_futureOrders, _filteredOrders)],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateOrderScreen()),
          );
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
  }
}

bool areDatesOnSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}
