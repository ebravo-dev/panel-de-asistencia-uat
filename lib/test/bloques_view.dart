import 'package:dashboard_uat_asistencia/constantes/bloques.dart';
import 'package:flutter/material.dart';

class BloquesView extends StatefulWidget {
  const BloquesView({super.key});

  @override
  State<BloquesView> createState() => _BloquesViewState();
}

class _BloquesViewState extends State<BloquesView> {
  List<String> dias = [
    'Lunes',
    'Martes',
    'Miercoles',
    'Jueves',
    'Viernes',
    'Sabado',
    'Domingo',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dia de la semana'),
      ),
      body: Column(
        children: [
          for (var i = 0; i < 7; i++)
            ListTile(
              title: Text(dias[i]),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Scaffold(
                        appBar: AppBar(
                          title: const Text('horas'),
                        ),
                        body: ListView(
                          children: [
                            for (var hora in calendario[i].keys)
                              ListTile(
                                title: Text(hora),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return Scaffold(
                                          appBar: AppBar(
                                            title: const Text('Bloques'),
                                          ),
                                          body: ListView(
                                            children: [
                                              for (var bloque
                                                  in calendario[i][hora].keys)
                                                ListTile(
                                                  title: Text(bloque),
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return Scaffold(
                                                            appBar: AppBar(
                                                              title: const Text(
                                                                  'Salones'),
                                                            ),
                                                            body: ListView(
                                                              children: [
                                                                for (var salon
                                                                    in calendario[i][hora]
                                                                            [
                                                                            bloque]
                                                                        .keys)
                                                                  ListTile(
                                                                    title: Text(salon +
                                                                        ' ' +
                                                                        calendario[i][hora][bloque][salon]
                                                                            [
                                                                            'materia']),
                                                                    subtitle: Text(calendario[i][hora][bloque]
                                                                            [
                                                                            salon]
                                                                        [
                                                                        'titular']),
                                                                    leading: Text(calendario[i][hora][bloque]
                                                                            [
                                                                            salon]
                                                                        [
                                                                        'grupo']),
                                                                    trailing: Text(calendario[i][hora][bloque]
                                                                            [
                                                                            salon]
                                                                        [
                                                                        'clave']),
                                                                  ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
