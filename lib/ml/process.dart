//processes incoming images
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';
import 'package:wild_life_mobile/ml/detection.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:developer' as developer;

Classifier? classifier;

class Classifier {
  Interpreter? _model;
  late List<String> _labels;

  late String _modelPath;
  late String _labelPath;

  // Shape
  late List<List<int>> _outputShapes;

  /// Types of output tensors
  late List<TfLiteType> _outputTypes;

  final int _size = 256;
  final double _scoreThreshold =
      0.7; //how willing are we to accept a prediction
  final int _threadCount = 4;
  final int _numResults = 10;

  Classifier(String modelPath, String labelPath) {
    _modelPath = modelPath;
    _labelPath = labelPath;
    _outputShapes = [];
    _outputTypes = [];
    _labels = [];
  }

  void dispose() {
    if (_model != null) {
      _model!.close();
    }
  }

  void _loadModel() async {
    if (_model != null) return;
    _model = await Interpreter.fromAsset(_modelPath,
        options: InterpreterOptions()..threads = _threadCount);
    var outputTensors = _model!.getOutputTensors();
    for (var tensor in outputTensors) {
      _outputShapes.add(tensor.shape);
      _outputTypes.add(tensor.type);
    }
  }

  void _loadLabels() async {
    if (_model == null) return;
    _labels = await FileUtil.loadLabels(_labelPath);
  }

  void load() async {
    _loadModel();
    _loadLabels();
  }

  //Format image for processing
  Future<TensorImage> _formatImage(File image) async {
    //resize image to fit 256x256
    TensorImage tensorImage = TensorImage.fromFile(image);
    int baseScaleSize = max(tensorImage.height, tensorImage.width);
    ImageProcessor imageProcessor = ImageProcessorBuilder()
        // Padding the image
        .add(ResizeWithCropOrPadOp(baseScaleSize, baseScaleSize))
        // Resizing to input size
        .add(ResizeOp(_size, _size, ResizeMethod.BILINEAR))
        .build();
    tensorImage = imageProcessor.process(tensorImage);
    return tensorImage;
  }

  //Process image and return predictions
  Future<List<Detection>> processImage(File image) async {
    //processes image
    developer.log("Processing Image");
    TensorImage fixed = await _formatImage(image);
    List<Detection> predictions = [];
    if (_model == null) {
      return predictions;
    }
    TensorBuffer outLocations = TensorBufferFloat(_outputShapes[0]);
    TensorBuffer outClasses = TensorBufferFloat(_outputShapes[1]);
    TensorBuffer outScores = TensorBufferFloat(_outputShapes[2]);
    TensorBuffer outNumLocations = TensorBufferFloat(_outputShapes[3]);
    List<Object> objects = [fixed.buffer];
    Map<int, Object> outputs = {
      0: outLocations.buffer,
      1: outClasses.buffer,
      2: outScores.buffer,
      3: outNumLocations.buffer
    };
    _model!.runForMultipleInputs(objects, outputs);
    //organize predictions
    int numPredictions = min(_numResults, outNumLocations.getIntValue(0));
    int labelOffset = 1;

    List<Rect> locations = BoundingBoxUtils.convert(
      tensor: outLocations,
      valueIndex: [1, 0, 3, 2],
      boundingBoxAxis: 2,
      boundingBoxType: BoundingBoxType.BOUNDARIES,
      coordinateType: CoordinateType.RATIO,
      height: _size,
      width: _size,
    );
    for (int i = 0; i < numPredictions; i++) {
      double score = outScores.getDoubleValue(i);
      if (score > _scoreThreshold) {
        predictions.add(Detection(
            Box(locations[i].left, locations[i].top, locations[i].right,
                locations[i].bottom),
            score,
            _labels[outClasses.getIntValue(i) + labelOffset]));
      }
    }
    developer.log("Predictions Complete", name: "process.dart");
    return predictions;
  }
}
