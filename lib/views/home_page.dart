import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_uat_asistencia/widgets/dropdown_custom.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:dashboard_uat_asistencia/controllers/archivo_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ArchivoController archivoController = ArchivoController();
  final DropdownButtonExample _dropdownButtonExample = DropdownButtonExample();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CREAR NUEVO CICLO'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Ciclo Escolar:'),
                _dropdownButtonExample,
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () async {
                    await archivoController.abrirExcel();
                    setState(() {});
                  },
                  label: const Text('Seleccionar Archivo Excel'),
                  icon: const Icon(Icons.search),
                ),
                const SizedBox(height: 20),
                archivoController.archivo != null
                    ? Text(archivoController.archivo!.files.single.name)
                    : const Text('No se ha seleccionado un archivo'),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: archivoController.archivo == null
                      ? null
                      : () async {
                          showDialog(
                              context: context,
                              builder: (_) => const AlertDialog(
                                    title: Text('Cargando...'),
                                    content: Text(
                                        'Espere un momento, este proceso puede tardar varios minutos\nya que es un proceso pesado'),
                                  ));
                          await Future.delayed(
                              const Duration(seconds: 1), () {});
                          archivoController.leerExcel();
                          // archivoController.crearMapaHorarios();
                          if (mounted) Navigator.pop(context);

                          // archivoController.crearMapaHorarios();
                          setState(() {});
                        },
                  label: const Text('Construir Ciclo'),
                  icon: const Icon(Icons.build),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: archivoController.profesoresMapa.isEmpty
                      ? null
                      : () async {
                          var ciclo = _dropdownButtonExample.select.select;
                          var profesores = archivoController.profesoresMapa;

                          var refCiclo = FirebaseFirestore.instance
                              .collection('ciclos')
                              .doc(ciclo);

                          showDialog(
                              context: context,
                              builder: (_) => const AlertDialog(
                                    title:
                                        Text('Almacenando En Base de Datos...'),
                                    content: LinearProgressIndicator(),
                                  ));

                          var refProfesores = refCiclo.collection('profesores');

                          profesores.forEach((key, value) async {
                            await refProfesores.doc(key).set(value);
                          });

                          if (mounted) Navigator.pop(context);
                        },
                  label: const Text('Cargar Ciclo'),
                  icon: const Icon(Icons.upload),
                ),
                // ElevatedButton(
                //   onPressed: () async {
                //     // var ref =
                //     //     FirebaseDatabase.instance.ref('2023 - 1 Primavera');
                //     // await ref.remove();
                //     var ref2 = FirebaseDatabase.instance.ref('2023 - 3 Otoño');
                //     await ref2.remove();
                //   },
                //   child: const Text('eliminarxd'),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
