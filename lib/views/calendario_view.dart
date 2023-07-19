import 'package:dashboard_uat_asistencia/constantes/bloques.dart';
import 'package:flutter/material.dart';

class CalendarioView extends StatefulWidget {
  const CalendarioView({super.key});

  @override
  State<CalendarioView> createState() => _CalendarioViewState();
}

class _CalendarioViewState extends State<CalendarioView> {
  List<String> horas = [
    '7:00 - 8:00',
    '8:00 - 9:00',
    '9:00 - 10:00',
    '10:00 - 11:00',
    '11:00 - 12:00',
    '12:00 - 13:00',
    '13:00 - 14:00',
    '14:00 - 15:00',
    '15:00 - 16:00',
    '16:00 - 17:00',
    '17:00 - 18:00',
    '18:00 - 19:00',
    '19:00 - 20:00',
    '20:00 - 21:00',
  ];

  List<String> diasSemanas = [
    'Lunes',
    'Martes',
    'Miercoles',
    'Jueves',
    'Viernes',
  ];

  String obtenerSalones(Map<String, dynamic> bloque, hora) {
    bloque.values.toList().sort((a, b) => a['materia'].compareTo(b['materia']));

    List<String> salones = [];
    bloque.forEach((key, value) {
      salones.add('$key: ${value['materia'].toString()}');
    });

    return salones.join('\n ------------------------ \n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
              ),
              for (var dia in diasSemanas)
                Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      dia,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  for (var hora in horas)
                    Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          hora,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                ],
              ),
              for (var dia in calendario)
                Column(
                  children: [
                    for (var hora in horas)
                      if (dia[hora] != null)
                        Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                            ),
                          ),
                          child: ListView(
                            children: [
                              Center(
                                child: Text(
                                  obtenerSalones(dia[hora]['A'], hora),
                                  style: const TextStyle(fontSize: 10),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                        )
                  ],
                )
            ],
          )
        ],
      ),
    );
  }
}
