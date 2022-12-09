import 'package:flutter/material.dart';
import 'package:wild_life_mobile/ml/view.dart';
// import 'package:wild_life_mobile/util.dart';
import 'package:wild_life_mobile/ml/process.dart';

// 	override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray): Boolean {
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //check for internet connection
  // hasInternet().then((bool hasInternet) {
  //   if (!hasInternet) {
  //     classifier = Classifier('models/beta.tflite', 'assets/models/labels.txt');
  //     classifier!.load();
  //   }
  // }).catchError((_) {
  //   classifier = Classifier('models/beta.tflite', 'assets/models/labels.txt');
  //   classifier!.load();
  // });
  classifier = Classifier();
  classifier!.load('models/beta.tflite', 'models/labels.txt');
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
