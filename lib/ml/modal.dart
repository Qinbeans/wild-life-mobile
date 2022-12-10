// ignore_for_file: camel_case_types

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wild_life_mobile/ml/detection.dart';
import 'package:wild_life_mobile/model/image.dart';
import 'dart:developer' as developer;

class modal extends StatefulWidget {
  final FullResult result;
  const modal({Key? key, required this.result}) : super(key: key);

  @override
  modalState createState() => modalState();
}

class modalState extends State<modal> {
  String _path = '';
  String _name = '';
  List<Widget> detectionWidgets = [];

  @override
  void initState() {
    super.initState();
    _path = widget.result.data;
    _name = widget.result.getName();
    developer.log(_path);
    //widget.result.detections.length
    for (var i = 0; i < widget.result.detections.length; i++) {
      // developer.log(i.toString());
      // developer.log(widget.result.detections[i].label);
      // developer.log(widget.result.detections[i].confidence.toString());
      // developer.log(widget.result.detections[i].box.toString());
      if (widget.result.detections[i].confidence > 1) {
        detectionWidgets.add(
          Container(
              height: 40,
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 58, 58, 58),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.result.detections[i].label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      )),
                  const Padding(padding: EdgeInsets.all(10)),
                  Text(widget.result.detections[i].confidence.toString(),
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 145, 142, 142),
                        fontSize: 18,
                      )),
                ],
              )),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: const Color.fromARGB(255, 37, 37, 37),
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 37, 37, 37),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: const Text("Results"),
              //titleTextStyle: TextStyle(fontSize: 30),
            ),
            //////////Body/////////
            body: Container(
                padding: const EdgeInsets.all(10), //padding for the whole page
                child: ListView(
                  shrinkWrap: true,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView(
                      shrinkWrap: true,
                      children: [Image.file(File(_path))],
                      //child: Image.file(File(_path)),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),

                    const Text(
                      "Detections",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    //MAKE THIS LIST
                    Column(
                      children: detectionWidgets,
                    ),
                    //MAKE THIS LIST
                    const Padding(padding: EdgeInsets.all(5)),
                    const Text(
                      "Upload",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(5)),
                    Container(
                      height: 100,
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 58, 58, 58),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "name",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                //_name,
                                "CHANGE",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 145, 142, 142),
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ))));
  }
}
