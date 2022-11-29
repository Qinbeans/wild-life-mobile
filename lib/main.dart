import 'package:flutter/material.dart';
import 'package:wild_life_mobile/ml/view.dart';
import './ml/process.dart';
// 	override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray): Boolean {

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  classifier = Classifier('models/beta.tflite', 'assets/models/labels.txt');
  classifier!.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromARGB(255, 37, 37, 37),
          fontFamily: 'Roboto'),
      home: const MLPage(),
    );
  }
}
