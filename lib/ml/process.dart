import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:wild_life_mobile/ml/detection.dart';

import 'package:image/image.dart';
import 'dart:io';
import 'package:flutter_vision/flutter_vision.dart';

Processor? classifier;

class Processor {
  FlutterVision classifier = FlutterVision();
  String modelDir = "";
  String labelDir = "";
  final threadCount = 4;
  final threshold = 0.7;
  final imageSize = 512;
  //constructor
  Processor({required this.modelDir, required this.labelDir});

  void dispose() async {
    await classifier.closeYoloModel();
  }

  //load model
  Future<void> loadModel() async {
    final response = await classifier.loadYoloModel(
        modelPath: modelDir,
        labels: labelDir,
        numThreads: threadCount,
        useGpu: false);
    if (response.type == "success") {
      developer.log("Model loaded successfully");
    } else {
      developer.log("Model failed to load");
    }
  }

  List<Uint8List> formatImage(File image) {
    var input = decodeImage(image.readAsBytesSync())!;
    return [input.getBytes()];
  }

  //detect objects
  Future<List<Detection>> forward(File input) async {
    final image = formatImage(input);
    //format image
    final response = await classifier.yoloOnFrame(
        bytesList: image,
        imageHeight: imageSize,
        imageWidth: imageSize,
        confThreshold: threshold);
    if (response.type == "error") {
      developer.log("Error: ${response.message}");
      return [];
    }
    //get detections
    final rawDetections = response.data as List<Map<String, dynamic>>;
    //convert to Detection objects
    final detections = rawDetections.map((e) => Detection.fromMap(e)).toList();
    return detections;
  }
}
