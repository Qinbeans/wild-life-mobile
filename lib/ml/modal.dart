// ignore_for_file: camel_case_types

import 'dart:ffi';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wild_life_mobile/ml/detection.dart';
import 'package:wild_life_mobile/model/image.dart';
import 'dart:developer' as developer;
import 'package:wild_life_mobile/ml/view.dart';

class Modal extends StatefulWidget {
  final FullResult result;
  const Modal({Key? key, required this.result}) : super(key: key);

  @override
  ModalState createState() => ModalState();
}

class ModalState extends State<Modal> {
  String _path = '';
  String _name = '';
  String _nameShortened = '';
  double _size = 0;
  List<Widget> detectionWidgets = [];

  @override
  void initState() {
    super.initState();
    _path = widget.result.data;
    _name = widget.result.getName();
    _nameShortened = "...${_name.substring(_name.length - 15)}";
    dirsize();
    //widget.result.detections.length
    for (var i = 0; i < 10; i++) {
      // developer.log(i.toString());
      // developer.log(widget.result.detections[i].label);
      //developer.log(widget.result.detections[i].confidence as String);
      // developer.log(widget.result.detections[i].box.toString());
      if (widget.result.detections[i].confidence > 0.90) {
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
        detectionWidgets.add(const Padding(padding: EdgeInsets.all(3)));
      }
    }
  }

  void dirsize() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(join(directory.path, 'results.json'));
    _size = file.lengthSync() / 100000;
    setState(() {
      _size = _size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
        backgroundColor: const Color.fromARGB(255, 37, 37, 37),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 37, 37, 37),
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
                Column(
                  children: detectionWidgets,
                ),
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
                  height: 75,
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
                        children: [
                          const Text(
                            "name",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            _nameShortened,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 145, 142, 142),
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.all(5)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "size",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "$_size MB",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 145, 142, 142),
                              fontSize: 18,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ))));
  }
}
