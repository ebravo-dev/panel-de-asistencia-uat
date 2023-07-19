import 'package:flutter/material.dart';

/// Flutter code sample for [DropdownButton].

const List<String> list = <String>[
  '2023 - 3 Otoño',
  '2023 - 2 Verano',
  '2023 - 1 Primavera',
];

class FixInt {
  String select = '2023 - 3 Otoño';
}

class DropdownButtonExample extends StatefulWidget {
  final FixInt select = FixInt();
  DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      dropdownColor: Colors.white,
      focusColor: Colors.white,
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
          widget.select.select = value;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
