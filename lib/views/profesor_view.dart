import 'package:flutter/material.dart';

class ProfesorView extends StatefulWidget {
  const ProfesorView({super.key});

  @override
  State<ProfesorView> createState() => _ProfesorViewState();
}

class _ProfesorViewState extends State<ProfesorView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profesores'),
      ),
      body: ListView(
        children: const [],
      ),
    );
  }
}

class AulasView extends StatefulWidget {
  final String bloque;
  final Map<String, dynamic> aulas;
  const AulasView({super.key, required this.aulas, required this.bloque});

  @override
  State<AulasView> createState() => _AulasViewState();
}

class _AulasViewState extends State<AulasView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bloque),
      ),
      body: ListView(
        children: [
          for (var aulaKey in widget.aulas.keys) Text(aulaKey),
        ],
      ),
    );
  }
}
