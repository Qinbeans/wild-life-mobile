// ignore_for_file: camel_case_types
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//Just need confidence and image path. Look at results object in image.dart
class UploadResultState extends StatelessWidget {
  final double confidence;
  final String imageName;

  const UploadResultState(
      {Key? key, required this.confidence, required this.imageName})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
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
                  Text(imageName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      )),
                  const Padding(padding: EdgeInsets.all(3)),
                  RichText(
                      text: TextSpan(children: [
                    const WidgetSpan(
                        child: FaIcon(FontAwesomeIcons.check,
                            size: 15, color: Colors.green)),
                    TextSpan(
                        text: (confidence > 0.5)
                            ? "  Irritants Detected"
                            : "  No Irritants",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        )),
                  ])),
                  const Padding(padding: EdgeInsets.all(3)),
                  RichText(
                      text: TextSpan(children: [
                    const WidgetSpan(
                        child: FaIcon(FontAwesomeIcons.magnifyingGlass,
                            size: 15, color: Colors.white)),
                    TextSpan(
                        text: (confidence > 0.5) ? "  Poison Oak" : "  na",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        )),
                  ])),
                  const Padding(padding: EdgeInsets.all(3)),
                  Text("$confidence%  Confidence",
                      style: const TextStyle(
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
