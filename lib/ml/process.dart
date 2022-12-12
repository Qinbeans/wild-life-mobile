import 'dart:developer' as developer;

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

  //reformat image to fit 512x512, if the image is smaller, pad it
  Image formatImage(File image) {
    var input = decodeImage(image.readAsBytesSync())!;
    //resize image
    input = copyResize(input, width: imageSize, height: imageSize);
    //pad image
    input = copyInto(Image(imageSize, imageSize), input,
        dstX: 0, dstY: 0, blend: false);
    return input;
  }

  //detect objects
  Future<List<Detection>> forward(File input) async {
    final image = formatImage(input);
    //convert into byte list
    final bytesList = [image.getBytes()];
    //format image
    final response = await classifier.yoloOnFrame(
        bytesList: bytesList,
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
