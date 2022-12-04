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
            //////////Body/////////
            body: Container(
                padding: const EdgeInsets.all(10), //padding for the whole page
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        children: const [
                          //Image
                          // Padding(padding: EdgeInsets.all(10)),
                          //Text
                        ],
                      ),
                    )),
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
                    Flexible(
                        child: Container(
                            height: 40,
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromARGB(255, 58, 58, 58),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text("Plant Name",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    )),
                                Padding(padding: EdgeInsets.all(10)),
                                Text("10.2%",
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 145, 142, 142),
                                      fontSize: 18,
                                    )),
                              ],
                            ))),
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
                                "image.png",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 145, 142, 142),
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "type",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                "image/png",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 145, 142, 142),
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "size",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                "x.xx MB",
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
