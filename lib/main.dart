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
              //leadingWidth: 20,
              centerTitle: true,
              //title: const Text('Wildlife'),
              title: Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      FaIcon(FontAwesomeIcons.leaf, color: Colors.green),
                      Text(" Wildlife"),
                    ]),
              )
              //titleTextStyle: TextStyle(fontSize: 30),
              ),

          //BODY ---------------------
          body: Container(
            padding: const EdgeInsets.all(20),
            child: Row(children: [
              Column(
                children: const [
                  Text("New Upload",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      )),
                  ElevatedButton(
                      onPressed: null,
                      child: Icon(
                        FontAwesomeIcons.camera,
                        color: Colors.white,
                      )),
                ],
              ),
              Column(
                children: [
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          //backgroundColor: Colors.green,
                          ),
                      onPressed: null,
                      icon: const Icon(FontAwesomeIcons.image,
                          color: Colors.white),
                      label: const Text("Upload",
                          style: TextStyle(color: Colors.white)))
                ],
              )
            ]),
          )),
    );
  }
}
