import 'package:dashboard_uat_asistencia/controllers/firestore_controller.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quick_notify/quick_notify.dart';

class EnVivoFaltasYReportes extends StatefulWidget {
  final String ciclo;
  const EnVivoFaltasYReportes({
    super.key,
    required this.ciclo,
  });

  @override
  EnVivoFaltasYReportesState createState() => EnVivoFaltasYReportesState();
}

class EnVivoFaltasYReportesState extends State<EnVivoFaltasYReportes> {
  bool saberIntervalo(String horarioProfesor) {
    String horarioActual =
        '${DateTime.now().hour}:00-${DateTime.now().hour + 1}:00';
    if (horarioActual == horarioProfesor) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Expanded(
              child: Text(
                'Faltantes',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Text(
                'Reportes',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: StreamBuilder(
                stream: verProfesores(widget.ciclo),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    int reportesLocales = GetStorage().read('faltantes') ?? 0;

                    if (reportesLocales != snapshot.data?.docs.length) {
                      GetStorage()
                          .write('faltantes', snapshot.data?.docs.length);

                      QuickNotify.notify(
                        title: 'Profesores aún no llegan a clase',
                        content:
                            'Revisa la lista de profesores para ver más detalles',
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(snapshot.data?.docs[index]['titular']),
                          subtitle: Text(snapshot.data?.docs[index]['horario']),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: verReportes(widget.ciclo),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    int reportesLocales = GetStorage().read('reportes') ?? 0;

                    if (reportesLocales != snapshot.data?.docs.length) {
                      GetStorage()
                          .write('reportes', snapshot.data?.docs.length);

                      QuickNotify.notify(
                        title: 'Tienes nuevos reportes',
                        content: 'Revisa la lista de reportes',
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        var id = index.toString();
                        var aux = id.split('_');
                        var salon = aux[0];
                        return ListTile(
                          title: Text(snapshot.data?.docs[index]['codigo']),
                          subtitle: Text(snapshot.data?.docs[index]['mensaje']),
                          trailing: Text(snapshot.data?.docs[index]['fecha']),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
