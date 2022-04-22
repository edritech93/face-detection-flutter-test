import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';

import 'face_painter.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FaceDetector _faceDetector = FaceDetector(
      options: const FaceDetectorOptions(mode: FaceDetectorMode.accurate));
  List<Face> faces = <Face>[];
  String? imagePath;

  void _onPickImage() async {
    print("_onPickImage");
    final ImagePicker _picker = ImagePicker();
    final XFile? xFile = await _picker
        .pickImage(source: ImageSource.gallery)
        .catchError((error) {
      print("Error 1 => $error");
    });
    print("xFile 1 => $xFile");
    setState(() {
      imagePath = xFile?.path;
    });
    if (xFile != null) {
      print("xFile => ${xFile.path}");
      final inputImage = InputImage.fromFilePath(xFile.path);
      List<Face> faceList = await _faceDetector.processImage(inputImage);
      print("faceList => ${faceList.length}");
      setState(() {
        faces = faceList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Detection'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (imagePath == null)
            const Center(
              child: Text('Test pick your image'),
            ),
          if (imagePath != null)
            Image.file(
              File(imagePath!),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.9,
            ),
          if (faces.isNotEmpty)
            CustomPaint(
              painter: FacePainter(
                face: faces.first,
                imageSize: const Size(100, 100),
                label: 'User',
                isCorrect: false,
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onPickImage(),
        tooltip: 'Library',
        child: const Icon(Icons.library_add),
      ),
    );
  }
}
