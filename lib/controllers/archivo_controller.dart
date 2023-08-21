import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:universal_html/html.dart' as html;

class ArchivoController {
  FilePickerResult? archivo;
  Map<String, dynamic> profesoresMapa = {};
  List<Map<String, dynamic>> calendario = [
    {}, //LUN
    {}, //MAR
    {}, //MIE
    {}, //JUE
    {}, //VIE
    {}, //SAB
    {}, //DOM
  ];

  crearMapaHorarios() {
    //se crea un mapa con los horarios de los profesores

    for (var profesor in profesoresMapa.values) {
      for (var horario in profesor['horarios']) {
        String aula = horario['aula'];
        String bloque = aula.split('-')[0];

        for (int i = 0; i < 7; i++) {
          String horas = horario['dias'][i];
          if (horas != '-') {
            int horaInicio = int.parse(horas.split(':')[0]);
            int horaFin = int.parse(horas.split('-')[1].split(':')[0]);
            while (horaInicio < horaFin) {
              horas = '$horaInicio:00 - ${horaInicio + 1}:00';
              if (calendario[i].containsKey(horas)) {
                if (calendario[i][horas]!.containsKey(bloque)) {
                  calendario[i][horas]![bloque][aula] = horario;
                } else {
                  calendario[i][horas]![bloque] = {aula: horario};
                }
              } else {
                calendario[i][horas] = {
                  bloque: {aula: horario}
                };
              }
              horaInicio++;
            }
          }
        }
      }
    }

    descargar(calendario);
  }

  Future<void> abrirExcel() async {
    try {
      //abrir el explorador de archivos, solo se pueden seleccionar archivos .xlsx
      archivo = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
        allowMultiple: false,
      );
      //imprimir nombre del archivo
      // print(archivo!.files.single.name);
    } catch (e) {
      // print('Error al seleccionar archivos: $e');
    }
  }

  void leerExcel() {
    try {
      if (archivo != null) {
        String key = '';
        //se decodifican los bytes del archivo
        Uint8List? bytes = archivo!.files.single.bytes;
        Excel excel = Excel.decodeBytes(bytes!);
        Sheet tabla = excel.tables['Sheet1']!;

        //primer for para recorrer la hoja de excel, como se sabe que solo tiene una hoja, se puede acceder directamente, se empieza en la fila 7 porque no contiene información relevante antes de esa fila
        // print('empieza el for');
        for (int i = 7; i < tabla.rows.length; i++) {
          // print(i);
          List<Data?> row = tabla.rows[i];
          //si la primera celda es diferente de null, es porque contiene información
          if (row[0] != null) {
            //si la primera celda contiene un numero, es un profesor y ese numero es su id
            //si no contiene un numero, es un horario de un profesor
            if (row[0]!.value.toString().contains(RegExp(r'[0-9]'))) {
              //como varios datos estan en la misma celda, se separan por medio de un split
              List<String> datos =
                  row[0]!.value.toString().substring(8).split(' - ');
              String nombre = datos[0];
              String tipo = datos[1];
              String codigo = datos[2];
              String id = row[0]!.value.toString().substring(0, 5);

              //se crea la llave del profesor para el mapa
              key = '$id-$nombre';

              //se agrega el profesor al mapa
              profesoresMapa[key] = {
                'id': id,
                'nombre': nombre,
                'tipo': tipo,
                'codigo': codigo,
                'materias': {},
                'lastUpdate': FieldValue.serverTimestamp(),
              };

              //se salta una fila porque no contiene información relevante
              i = i + 1;
            } else {
              //se agrega el horario al profesor a la lista de horarios
              var clave = row[1]!.value.toString();
              var grupo = row[0]!.value.toString();
              profesoresMapa[key]['materias'][grupo + clave] = {
                'grupo': grupo,
                'clave': clave,
                'materia': row[2]!.value.toString(),
                'sit': row[3]!.value.toString(),
                'ff': row[4]!.value.toString(),
                'horario': [
                  row[5]!.value.toString(),
                  row[6]!.value.toString(),
                  row[7]!.value.toString(),
                  row[8]!.value.toString(),
                  row[9]!.value.toString(),
                  row[10]!.value.toString(),
                  row[11]!.value.toString(),
                ],
                'hrsSem': row[12]!.value.toString(),
                'hrsM': row[13]!.value.toString(),
                'hrsNom': row[14]!.value.toString(),
                'aula': row[15]!.value.toString(),
                'inscritos': row[16]!.value.toString(),
                // 'asistencias': {
                //   //'17/06': {'asis': false, 'imagen': ''},
                // },
                'titular': key,
                'suplente': 'Sin suplente',
              };
            }
          }
        }

        // descargar(profesoresMapa);
      }
    } catch (e) {
      // print('Error al leer el archivo: $e');
    }
    print(profesoresMapa.length);
  }

  descargar(mapa) {
    String jsonString = jsonEncode(mapa);
    final bytesJson = utf8.encode(jsonString);
    final blob = html.Blob([bytesJson]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'datos.json';
    html.document.body?.children.add(anchor);
    anchor.click();
    html.document.body?.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }
}
