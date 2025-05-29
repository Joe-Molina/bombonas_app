import 'package:bombonas_app/components/app_bar.dart';
import 'package:bombonas_app/data/models/clients_response.dart';
import 'package:bombonas_app/data/models/form_post.dart';
import 'package:bombonas_app/data/repository.dart';
import 'package:bombonas_app/styles/input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateOrderScreen extends StatefulWidget {
  final List<ClientsResponse> clients;

  const CreateOrderScreen({super.key, required this.clients});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  List<ClientsResponse> _clients = [];
  DateTime? _selectedDate;
  int selectedClient = 0;
  FormOrder? formOrderState;
  //form key
  final _formGlobalKey = GlobalKey<FormState>();

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _kg10Controller = TextEditingController();
  final TextEditingController _kg18Controller = TextEditingController();
  final TextEditingController _kg21Controller = TextEditingController();
  final TextEditingController _kg27Controller = TextEditingController();
  final TextEditingController _kg43Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 1. Accede a las props iniciales desde 'widget' en initState
    _clients = widget.clients;
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 39, 39, 39),
      appBar: appBarComponent("Crear orden"),
      body: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formGlobalKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                selectClient(),
                datePicker(context),
                SizedBox(
                  height: screenSize.height / 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        inputCantCilindros(_kg10Controller, "Cantidad 10 kg"),
                        inputCantCilindros(_kg18Controller, "Cantidad 18 kg"),
                        inputCantCilindros(_kg21Controller, "Cantidad 21 kg"),
                        inputCantCilindros(_kg27Controller, "Cantidad 27 kg"),
                        inputCantCilindros(_kg43Controller, "Cantidad 43 kg"),
                      ],
                    ),
                  ),
                ),
                sendInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField datePicker(BuildContext context) {
    return TextFormField(
      controller: _dateController,
      readOnly: true, // Hace que el campo no sea editable directamente
      onTap: () => _selectDate(context), // Abre el selector de fecha al tocar
      style: const TextStyle(color: Colors.white),
      decoration: inputStyle("Fecha de la orden"),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, selecciona una fecha.';
        }
        return null;
      },
    );
  }

  FilledButton sendInfo() {
    return FilledButton(
      onPressed: () async {
        if (_formGlobalKey.currentState!.validate()) {
          _formGlobalKey.currentState!.save();

          final order = FormOrder(
            clientId: selectedClient,
            date: _selectedDate!,
            orderDetail: OrdersDetailForm(
              kg10: int.parse(_kg10Controller.text),
              kg18: int.parse(_kg18Controller.text),
              kg21: int.parse(_kg21Controller.text),
              kg27: int.parse(_kg27Controller.text),
              kg43: int.parse(_kg43Controller.text),
            ),
          );

          try {
            final response = await Repository().createOrder(order);

            // Verificar si el widget está montado antes de cualquier operación con context
            if (!mounted) return;

            if (response.statusCode == 200) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Orden creada exitosamente')),
              );
              Navigator.pop(context, true);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${response.body}')),
              );
            }
          } catch (e) {
            // Verificar mounted también en el catch
            if (!mounted) return;

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error de conexión: $e')));
          }
        }
      },
      style: FilledButton.styleFrom(
        backgroundColor: Colors.grey[800],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: const Text("Add"),
    );
  }

  DropdownButtonFormField<ClientsResponse> selectClient() {
    return DropdownButtonFormField<ClientsResponse>(
      // value: selectedClient,
      dropdownColor: Colors.grey[800],
      decoration: InputDecoration(
        labelText: 'Selecciona un cliente',
        labelStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.grey[800],

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide.none,
        ),
        focusColor: Colors.black,
      ),
      items: _clients
          .map(
            (client) => DropdownMenuItem<ClientsResponse>(
              value: client,
              child: Text(
                client.name,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          )
          .toList(),
      onChanged: (ClientsResponse? value) {
        setState(() {
          selectedClient = value!.id;
        });
      },
    );
  }

  TextFormField inputCantCilindros(TextEditingController controller, title) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: inputStyle(title),
      maxLength: 3,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "debes ingresar una cantidad de cilindros";
        }
        return null;
      },
      onSaved: (value) {},
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
    }
  }
}
