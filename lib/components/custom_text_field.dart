import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != int.tryParse(_controller.text)) {
      _controller.text = widget.value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        label: Text(widget.label, style: const TextStyle(color: Colors.white)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
        ),
        border: const OutlineInputBorder(),
      ),
      onChanged: (value) {
        final parsedValue = int.tryParse(value) ?? 0;
        widget.onChanged(parsedValue);
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
