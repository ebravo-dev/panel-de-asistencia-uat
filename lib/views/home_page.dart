import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard_uat_asistencia/controllers/archivo_controller.dart';
import 'package:dashboard_uat_asistencia/controllers/firestore_controller.dart';
import 'package:dashboard_uat_asistencia/controllers/storage_controller.dart';
import 'package:dashboard_uat_asistencia/views/ver_en_vivo_faltas_reportes_view.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ArchivoController archivoController = ArchivoController();
  late Future<ListResult> futureFiles;
  late String ciclo = '';
  final double card_width_size = 320;
  String activo = '';
  int cantidad = 0;

  @override
  void initState() {
    super.initState();

    futureFiles = FirebaseStorage.instance.ref('/images').listAll();

    var month = DateTime.now().month;

    var temporada = month >= 1 && month <= 5
        ? 'Primavera'
        : month >= 6 && month <= 7
            ? 'Verano'
            : 'Otoño';
    var numero = temporada == 'Primavera'
        ? 1
        : temporada == 'Verano'
            ? 2
            : 3;

    ciclo = '${DateTime.now().year} - $numero $temporada';

    cantidadProfesores(ciclo).then((value) async {
      if (value > 0) {
        activo = 'Activo';
      } else {
        activo = 'Inactivo';
      }
      cantidad = value;

      if (mounted) {
        await Future.delayed(const Duration(milliseconds: 1000));
        setState(() {});
      }
    });
  }

  void showDialogoMantenimiento() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('En Mantenimiento'),
        content: const Text(
          'Esta funcion estará disponible en la siguiente actualización',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          'Panel de Control',
          style: TextStyle(
            fontSize: 60,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        toolbarHeight: 120,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: 10,
          ),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 30,
            runSpacing: 30,
            children: [
              Container(
                height: 450,
                width: card_width_size,
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 30,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Iniciar Ciclo',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Icon(
                      Icons.directions_run,
                      color: Colors.deepPurple,
                      size: 30,
                    ),
                    const SizedBox(height: 15),
                    const Text('Ciclo Actual'),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '$ciclo ',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          activo == ''
                              ? const WidgetSpan(
                                  child: SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ))
                              : TextSpan(
                                  text: activo,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: activo == 'Activo'
                                        ? Colors.green.shade700
                                        : Colors.deepOrange.shade800,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Paso 1'),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await archivoController.abrirExcel();
                        setState(() {});
                      },
                      label: const Text('Seleccionar Excel'),
                      icon: const Icon(Icons.search),
                    ),
                    const SizedBox(height: 20),
                    archivoController.archivo != null
                        ? Text(
                            archivoController.archivo!.files.single.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                            ),
                          )
                        : const Text('No se ha seleccionado un archivo',
                            style: TextStyle(fontSize: 11)),
                    const SizedBox(height: 15),
                    const Text('Paso 2'),
                    ElevatedButton.icon(
                      onPressed: archivoController.archivo == null
                          ? null
                          : () async {
                              showDialog(
                                  context: context,
                                  builder: (_) => const AlertDialog(
                                        title: Text('Cargando...'),
                                        content: Text(
                                          'Espere un momento, este proceso puede tardar varios minutos\n'
                                          'ya que es un proceso pesado',
                                        ),
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
                    const Text('Paso 3'),
                    ElevatedButton.icon(
                      onPressed: archivoController.profesoresMapa.isEmpty
                          ? null
                          : () async {
                              // var ciclo = _dropdownButtonExample.select.select;
                              var profesores = archivoController.profesoresMapa;

                              var refCiclo = FirebaseFirestore.instance
                                  .collection('ciclos')
                                  .doc(ciclo);

                              showDialog(
                                  context: context,
                                  builder: (_) => const AlertDialog(
                                        title: Text(
                                            'Almacenando En Base de Datos...'),
                                        content: LinearProgressIndicator(),
                                      ));

                              var refProfesores =
                                  refCiclo.collection('profesores');

                              profesores.forEach((key, value) async {
                                await refProfesores.doc(key).set(value);
                              });

                              if (mounted) Navigator.pop(context);
                            },
                      label: const Text('Cargar Ciclo'),
                      icon: const Icon(Icons.upload),
                    ),
                  ],
                ),
              ),
              Container(
                height: 450,
                width: card_width_size,
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 30,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Respaldo',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Icon(
                      Icons.save,
                      color: Colors.deepPurple,
                      size: 30,
                    ),
                    const SizedBox(height: 15),
                    const Text('Total de Imagenes'),
                    FutureBuilder<Object>(
                      future: fetchImageInfo(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data as Map<String, dynamic>;

                          return Text(
                            data['count'].toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else {
                          return const SizedBox(
                            height: 23,
                            width: 23,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    const Text('Peso total'),
                    FutureBuilder<Object>(
                      future: fetchImageInfo(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data as Map<String, dynamic>;

                          return Text(
                            data['totalBytes'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        } else {
                          return const SizedBox(
                            height: 23,
                            width: 23,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text('Paso 1'),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.download),
                      onPressed: () {
                        downloadFile(mounted, context);
                      },
                      label: const Text('Descargar Imagenes'),
                    ),
                    const SizedBox(height: 15),
                    const Text('Paso 2'),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.delete_forever),
                      onPressed: () async {
                        var confirm = await showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('¿Estas seguro?'),
                            content: const Text(
                              'Esta accion no se puede deshacer, asegurate de haber\ndescargado las imagenes antes de continuar',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text(
                                  'Aceptar',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (confirm) {
                          var files = await FirebaseStorage.instance
                              .ref('/images')
                              .listAll();
                          for (var ref in files.items) {
                            await ref.delete();
                          }
                        }
                      },
                      label: const Text(
                        'Liberar Espacio',
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Container(
                height: 450,
                width: card_width_size,
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 30,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Acciones',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Icon(
                      Icons.settings,
                      color: Colors.deepPurple,
                      size: 30,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Profesores Registrados',
                    ),
                    cantidad == 0
                        ? const SizedBox(
                            height: 23,
                            width: 23,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            '$cantidad',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.download),
                      onPressed: showDialogoMantenimiento,
                      label: const Text('Descargar Asistencia'),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.visibility),
                      onPressed: showDialogoMantenimiento,
                      label: const Text(
                        'Ver Profesor',
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Divider(),
                    const SizedBox(height: 15),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.warning_rounded),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EnVivoFaltasYReportes(
                              ciclo: ciclo,
                            ),
                          ),
                        );
                      },
                      label: const Text(
                        'Faltantes & Reportes',
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
