import 'package:flutter/material.dart';
import './ml/process.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  //initModel();
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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: const Color.fromARGB(255, 37, 37, 37),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 37, 37, 37),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const FaIcon(FontAwesomeIcons.leaf),
                color: Colors.green,
                onPressed: () {},
              ),
            ],
            title: const Text('Wildlife'),
          ),
          body: Container(
              child: Column(
                  children: [ElevatedButton(onPressed: null, child: null)]))),
    );
  }
}
