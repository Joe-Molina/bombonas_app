import 'package:bombonas_app/data/repository.dart';
import 'package:flutter/material.dart';

actualizarPago(context, order, paid) async {
  try {
    final response = await Repository().updatePaidOrder(
      order.id,
      order.payment,
    );

    Text text = paid ? Text('Pago borrado con exito') : Text('Pago registrado');

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: text));
      return true;
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${response.body}')));
    }
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Error de conexión: $e')));
  }
}
