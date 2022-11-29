import 'package:wild_life_mobile/ml/process.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'dart:io';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  test('processImage', () async {
    classifier =
        Classifier('assets/models/beta.tflite', 'assets/models/labels.txt');
    classifier!.load();
    var image = File('assets/images/test.jpeg');
    var result = await classifier!.processImage(image);
    expect(result, isNotNull);
  });
}
