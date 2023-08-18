import 'dart:html' as html;

import 'package:archive/archive.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

void downloadFile(mounted, context) async {
  ListResult result = await FirebaseStorage.instance.ref('/images').listAll();
  final zipEncoder = ZipEncoder();
  final zipArchive = Archive();
  List<Reference> allFiles = result.items;
  int max = allFiles.length;
  int progress = 0;
  ProgressDialog? progressDialog;
  if (mounted) {
    progressDialog = ProgressDialog(context: context);

    progressDialog.show(
      msg: 'Descargando archivos...',
      max: max,
      completed: Completed(),
    );
  }
  for (var ref in allFiles) {
    final bytes = await ref.getData();
    final imageFileName = ref.name;
    zipArchive.addFile(ArchiveFile(imageFileName, bytes!.length, bytes));

    if (mounted) {
      progressDialog?.update(
        value: ++progress,
        msg: 'Descargando archivos...',
      );
    }
  }

  if (mounted) {
    progressDialog?.update();
  }

  final List<int>? zipBytes = zipEncoder.encode(zipArchive);
  final blob = html.Blob([zipBytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final date = DateTime.now();
  html.AnchorElement(href: url)
    ..setAttribute("download", "imagenes_respaldo_${date.toString()}.zip")
    ..click();

  html.Url.revokeObjectUrl(url);
}

Widget verFotos() {
  return FutureBuilder<ListResult>(
    future: FirebaseStorage.instance.ref('/images').listAll(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.items.length,
          itemBuilder: (context, index) {
            var item = snapshot.data!.items[index];
            return ListTile(
              title: Text(item.name),
            );
          },
        );
      } else if (snapshot.hasError) {
        return Text(snapshot.error.toString());
      } else {
        return const CircularProgressIndicator();
      }
    },
  );
}

Future<Map<String, dynamic>> fetchImageInfo() async {
  var listResult = await FirebaseStorage.instance.ref('/images').listAll();

  int count = listResult.items.length;
  double totalBytes = 0;

  for (var item in listResult.items) {
    var metadata = await item.getMetadata();
    totalBytes += metadata.size!;
  }

  return {
    'count': count,
    'totalBytes': formatBytes(totalBytes),
  };
}

String formatBytes(double bytes) {
  var units = ["B", "KB", "MB", "GB", "TB"];
  var unitIndex = 0;

  while (bytes >= 1024 && unitIndex < units.length - 1) {
    bytes /= 1024;
    unitIndex++;
  }

  return "${bytes.toStringAsFixed(2)} ${units[unitIndex]}";
}
