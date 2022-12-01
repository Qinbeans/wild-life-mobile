// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class modal extends StatefulWidget {
  const modal({Key? key}) : super(key: key);

  @override
  modalState createState() => modalState();
}

class modalState extends State<modal> {
  var image;
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
            //////////Body//////////
            body: Row(
              children: [
                Flexible(
                    //Box for the image (TEMPORARY MOVE TO ANOTHE FILE)
                    child: Container(
                  height: 100,
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 58, 58, 58),
                  ),
                  child: Row(
                    children: [
                      //Image
                      Container(
                        height: 100,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 58, 58, 58),
                        ),
                        child: const Icon(
                          FontAwesomeIcons.image,
                          color: Colors.white,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(10)),
                      //Text
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [],
                      ),
                    ],
                  ),
                )),
                Flexible(
                    child: Container(
                        height: 100,
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 58, 58, 58),
                        ),
                        child: const Text("Poison Oak")))
              ],
            )));
  }
}
