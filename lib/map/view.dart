// ignore_for_file: camel_case_types

import 'package:flutter/services.dart';
import '../model/image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:camera/camera.dart';
import '../main.dart';

//Dispaly map and relevant map data
class mapPage extends StatefulWidget {
  const mapPage({Key? key}) : super(key: key);

  @override
  mapPageState createState() => mapPageState();
}

class mapPageState extends State<mapPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: const Color.fromARGB(255, 37, 37, 37),
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 37, 37, 37),
              //leadingWidth: 20,
              //centerTitle: true,
              //title: const Text('Wildlife'),+
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: const Text("Map"),
              //titleTextStyle: TextStyle(fontSize: 30),
            ),
            //////////Body//////////
            body: Container(
              padding: const EdgeInsets.all(20), //padding for the whole page
            )));
  }
}
