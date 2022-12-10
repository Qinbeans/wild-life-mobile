// Followed https://github.com/syu-kwsk/flutter_yolov5_app/blob/main/lib/data/model/classifier.dart
// Adapted to fit our model and code base

import 'dart:math';
import 'dart:developer' as developer;
import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import 'package:wild_life_mobile/ml/detection.dart';

Classifier? classifier;

class Classifier {
  late Interpreter? _interpreter;
  Interpreter? get interpreter => _interpreter;

  /// image size into interpreter
  static const int inputSize = 512;

  ImageProcessor? imageProcessor;
  late List<List<int>> _outputShapes;
  late List<TfLiteType> _outputTypes;
  late List<String> _labels;

  static const double objConfTh = 0.80;
  static const double clsConfTh = 0.80;

  late int spacing;
  late int clsNum;

  /// load interpreter
  Future<void> loadModel(String modelFileName) async {
    try {
      _interpreter = await Interpreter.fromAsset(
        modelFileName,
        options: InterpreterOptions()..threads = 4,
      );
      final outputTensors = _interpreter!.getOutputTensors();
      _outputShapes = [];
      _outputTypes = [];
      for (final tensor in outputTensors) {
        _outputShapes.add(tensor.shape);
        _outputTypes.add(tensor.type);
      }
      //[0][1][2] = [1, 16320, 9]
      spacing = _outputShapes[0][2] - 1;
    } on Exception catch (e) {
      developer.log(e.toString());
    }
  }

  void loadLabels(String labelFileName) async {
    try {
      _labels = await FileUtil.loadLabels("assets/$labelFileName");
      clsNum = _labels.length;
    } catch (e) {
      developer.log(e.toString());
    }
  }

  void load(String modelFileName, String labelFileName) async {
    await loadModel(modelFileName);
    loadLabels(labelFileName);
  }

  void printOutputShapes() {
    for (var i = 0; i < _outputShapes.length; i++) {
      developer.log("Shape: ${_outputShapes[i].toString()}");
    }
  }

  /// image pre process
  TensorImage getProcessedImage(TensorImage inputImage) {
    final padSize = max(inputImage.height, inputImage.width);

    imageProcessor ??= ImageProcessorBuilder()
        .add(
          ResizeWithCropOrPadOp(
            padSize,
            padSize,
          ),
        )
        .add(
          ResizeOp(
            inputSize,
            inputSize,
            ResizeMethod.BILINEAR,
          ),
        )
        .build();
    return imageProcessor!.process(inputImage);
  }

  List<Detection> predict(File image) {
    printOutputShapes();
    if (_interpreter == null) {
      return [];
    }

    var inputImage = TensorImage.fromFile(image);
    inputImage = getProcessedImage(inputImage);

    ///  normalize from zero to one
    List<double> normalizedInputImage = [];
    for (var pixel in inputImage.tensorBuffer.getDoubleList()) {
      normalizedInputImage.add(pixel / 255.0);
    }
    var normalizedTensorBuffer = TensorBuffer.createDynamic(TfLiteType.float32);
    normalizedTensorBuffer
        .loadList(normalizedInputImage, shape: [inputSize, inputSize, 3]);

    final inputs = [normalizedTensorBuffer.buffer];

    /// tensor for results of inference
    final outputLocations = TensorBufferFloat(_outputShapes[0]);
    final outputs = {
      0: outputLocations.buffer,
    };

    _interpreter!.runForMultipleInputs(inputs, outputs);

    /// make recognition
    final recognitions = <Detection>[];
    List<double> outputRes = outputLocations.getDoubleList();
    for (var i = 0; i < outputRes.length; i += 5 * clsNum) {
      //developer.log("i: $i");
      if (outputRes[i + 4] < objConfTh) continue;
      var maxConf = outputRes.sublist(i + 5, i + 5 + clsNum - 1).reduce(max);
      //developer.log(maxConf.toString());
      if (maxConf < clsConfTh) continue;
      var cls = outputRes.sublist(i + 5, i + 5 + clsNum - 1).indexOf(maxConf) %
          clsNum;
      //developer.log("cls: $cls");

      var box = Box(
        outputRes[i] * inputSize,
        outputRes[i + 1] * inputSize,
        outputRes[i + 2] * inputSize,
        outputRes[i + 3] * inputSize,
      );
      //developer.log(maxConf.toString());

      recognitions.add(
        Detection(
          box,
          maxConf,
          _labels[cls],
        ),
      );
    }
    return recognitions;
  }
}
