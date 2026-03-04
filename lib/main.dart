import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:flutter/material.dart';
import 'package:flutter_archive/flutter_archive.dart';

import 'gameplayer.dart';
import 'globalvars.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await uncompressfiles();

  runApp(MyApp());
}

Future uncompressfiles() async {
  final Directory docDir = await getApplicationDocumentsDirectory();
  final String localPath = docDir.path;
  File file = File(localPath + '/files2.zip');
  final imageBytes = await rootBundle.load("files2.zip");
  final buffer = imageBytes.buffer;
  await file.writeAsBytes(
      buffer.asUint8List(imageBytes.offsetInBytes, imageBytes.lengthInBytes));

  try {
    await ZipFile.extractToDirectory(zipFile: file, destinationDir: docDir);
    projpathcore = docDir.path;
    imagespath = projpathcore + "/images/";
    scenespath = projpathcore + "/scenes/";
    soundspath = projpathcore + "/sounds/";
  } catch (e) {
    print(e);
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Gameplayer(
        "scene1",
        isplayground: true,
      ),
    );
  }
}
