import 'package:flutter/material.dart';

class FilteringWidget extends StatefulWidget {
  const FilteringWidget({
    super.key,
    required this.onValueChanged,
    this.initialValue,
    required this.items,
  });
  final ValueChanged<String?> onValueChanged;
  final String? initialValue;
  final List<String> items;

  @override
  State<FilteringWidget> createState() => _FilteringWidgetState();
}

class _FilteringWidgetState extends State<FilteringWidget> {
  String? _selectedValue;

  // Change the value of the selected value and call the callback
  // @param newValue the new value to set
  void _changeValue(String? newValue) {
    setState(() {
      _selectedValue = newValue;
    });
    widget.onValueChanged(newValue);
  }

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: Text(widget.initialValue ?? 'Select'),
      value: _selectedValue,
      onChanged: (String? newValue) {
        _changeValue(newValue);
      },
      items: widget.items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      underline: const SizedBox.shrink(),
    );
  }
}
