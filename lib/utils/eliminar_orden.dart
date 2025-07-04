import 'package:flutter/material.dart';

Future<bool> deleteOrder(BuildContext context, int orderId) async {
  final bool? wasDeleted = await showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        decoration: BoxDecoration(color: const Color.fromARGB(255, 32, 32, 32)),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.white),
                title: const Text(
                  'Eliminar esta orden',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          ),
        ),
      );
    },
  );

  return wasDeleted ?? false;
}
