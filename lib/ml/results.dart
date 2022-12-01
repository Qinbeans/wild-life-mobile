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

//Just need confidence and image path. Look at results object in image.dart

class UploadResultState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
            //Box for the image (TEMPORARY MOVE TO ANOTHE FILE)
            child: Container(
          height: 120,
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
                children: [
                  const Text("Image Name",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      )),
                  const Padding(padding: EdgeInsets.all(3)),
                  RichText(
                      text: const TextSpan(children: [
                    WidgetSpan(
                        child: FaIcon(FontAwesomeIcons.check,
                            size: 15, color: Colors.green)),
                    TextSpan(
                        text: " Location",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        )),
                  ])),
                  const Padding(padding: EdgeInsets.all(3)),
                  RichText(
                      text: const TextSpan(children: [
                    WidgetSpan(
                        child: FaIcon(FontAwesomeIcons.magnifyingGlass,
                            size: 15, color: Colors.white)),
                    TextSpan(
                        text: " Species",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        )),
                  ])),
                  const Padding(padding: EdgeInsets.all(3)),
                  const Text("Confidence",
                      style: TextStyle(
                        color: Color.fromARGB(255, 175, 173, 173),
                        fontSize: 15,
                      )),
                ],
              ),
            ],
          ),
        ))
      ],
    );
  }
}
