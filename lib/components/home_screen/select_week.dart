import 'package:bombonas_app/utils/same_day.dart';
import 'package:flutter/material.dart';
import 'package:bombonas_app/utils/last_four_weeks.dart';

class SelectWeek extends StatefulWidget {
  const SelectWeek({super.key});

  @override
  State<SelectWeek> createState() => _SelectWeekState();
}

class _SelectWeekState extends State<SelectWeek> {
  List<DateTime> ultimasCuatroSemanas = getLastFourWeeksDays();
  DateTime? _selectedWeek;

  @override
  void initState() {
    super.initState();
    _selectedWeek = getLastFourWeeksDays().first;
  }

  @override
  Widget build(BuildContext context) {
    return selectWeek();
  }

  Form selectWeek() {
    final formGlobalKey = GlobalKey<FormState>();

    return Form(
      key: formGlobalKey,
      child: DropdownButtonFormField<DateTime>(
        // value: _selectedWeek,
        dropdownColor: Colors.grey[800],
        decoration: InputDecoration(
          labelText: 'Selecciona una semana',
          labelStyle: const TextStyle(color: Colors.white),
          filled: true,
          fillColor: Colors.grey[800],

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide.none,
          ),
          focusColor: Colors.black,
        ),
        items: ultimasCuatroSemanas
            .map(
              (week) => DropdownMenuItem<DateTime>(
                value: week,
                child: Text(
                  "${formatter(week)} / ${formatter(week.add(Duration(days: 4)))}",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            )
            .toList(),
        onChanged: (DateTime? value) {
          setState(() {
            if (value == null) return;
            // Verifica si la semana seleccionada es la misma que la actual
            if (_selectedWeek != null && sameDay(_selectedWeek!, value)) {
              return; // No hacer nada si es la misma semana
            }
            // Si es una semana diferente, actualiza el estado
            print(value);
            _selectedWeek = value;
          });
        },
      ),
    );
  }
}
