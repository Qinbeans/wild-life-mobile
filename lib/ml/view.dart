//displays the ML page
//Find out whether there is network connection.
//If there is no network connection, use the local model.

//take in an image
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wild_life_mobile/ml/detection.dart';
import 'package:wild_life_mobile/ml/modal.dart';
import 'package:wild_life_mobile/ml/process.dart';
import 'package:wild_life_mobile/model/image.dart';
import 'package:wild_life_mobile/map/view.dart';
import 'package:wild_life_mobile/ml/results.dart';
import 'package:wild_life_mobile/ml/io.dart';
import 'dart:developer' as developer;

var isConnected = false;

var history = <Results>[];

var widgetList = <Widget>[];

var gpsList = <GPS>[];

class MLPage extends StatefulWidget {
  const MLPage({Key? key}) : super(key: key);

  @override
  MLPageState createState() => MLPageState();
}

class MLPageState extends State<MLPage> {
  UploadRequest? uploadRequest;
  UploadResponse? uploadResponse;
  Location location = Location();
  LocationData? _locationData;
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    String imageName;
    widgetList = [
      Column(),
      const Text("Previous Uploads",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          )),
      // const Padding(padding: EdgeInsets.all(20)),
      TextButton(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20),
          ),
          onPressed: (() => deleteJson()),
          child: const Text("Clear",
              style: TextStyle(
                color: Colors.green,
                fontSize: 16,
              ))),
    ];
    readJson().then((history) => {
          //history = value,
          for (var i = 0; i < history.length; i++)
            {
              //grab the image from the path
              imageName = basename(File(history[i].data).path),
              widgetList.add(UploadResultState(
                  confidence: history[i].confidence, imageName: imageName)),
            }
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _refreshLocation() {
    setState((() {
      _checkLocationPermission();
    }));
  }

  void _getLocation() async {
    try {
      _locationData = await location.getLocation();
    } on PlatformException catch (_) {
      _locationData = LocationData.fromMap(<String, double>{
        'latitude': 0.0,
        'longitude': 0.0,
      });
    }
  }

  void _checkLocationPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _getLocation();
  }

  Future<FullResult?> _captureImage() async {
    _refreshLocation(); //update location
    final imagePicker = ImagePicker();
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.camera);
    if (image == null) {
      return null;
    }
    //convert image to bytes
    final bytes = await image.readAsBytes();
    //convert bytes to base64
    final base64 = base64Encode(bytes);
    final double long = _locationData == null
        ? 0.0
        : (_locationData!.longitude == null ? 0.0 : _locationData!.longitude!);
    final double lat = _locationData == null
        ? 0.0
        : (_locationData!.latitude == null ? 0.0 : _locationData!.latitude!);
    //create upload request
    uploadRequest = UploadRequest(
        name: image.path,
        type: image.path.split('.').last,
        location: GPS(latitude: lat, longitude: long),
        size: bytes.length,
        data: base64);
    //send upload request
    //for now don't send the request and process locally
    if (isConnected) {
      //send upload request to server
    }
    File file = File(image.path);
    final response = classifier!.predict(file);
    final fullres =
        FullResult(data: image.path, detections: response, local: true);

    return fullres;
  }

  Future<FullResult?> _pickfile() async {
    _refreshLocation(); //update location
    developer.log("Pick File Accessed");
    final imagePicker = ImagePicker();
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    }
    //convert image to bytes
    final bytes = await image.readAsBytes();
    //convert bytes to base64
    final base64 = base64Encode(bytes);
    final double long = _locationData == null
        ? 0.0
        : (_locationData!.longitude == null ? 0.0 : _locationData!.longitude!);
    final double lat = _locationData == null
        ? 0.0
        : (_locationData!.latitude == null ? 0.0 : _locationData!.latitude!);
    //create upload request
    uploadRequest = UploadRequest(
        name: image.path,
        type: image.path.split('.').last,
        location: GPS(latitude: lat, longitude: long),
        size: bytes.length,
        data: base64);
    gpsList.add(uploadRequest!.location);
    writeJsonGPS(gpsList);
    //send upload request
    //for now don't send the request and process locally
    if (isConnected) {
      //send upload request to server
    }

    File file = File(image.path);

    final List<Detection> response;
    // if (classifier != null) {
    //   response = await classifier!.processImage(file);
    // } else {
    //   response = [];
    // }

    if (classifier != null) {
      response = classifier!.predict(file);
    } else {
      response = [];
    }

    final fullres =
        FullResult(data: image.path, detections: response, local: true);

    developer.log("Pick File Complete");
    return fullres;
  }

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
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    FaIcon(FontAwesomeIcons.leaf, color: Colors.green),
                    Text(" Wildlife"),
                  ]),
              actions: [
                IconButton(
                  icon: const Icon(Icons.map),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MapPage()),
                    );
                  },
                ),
              ],
            ),
            //titleTextStyle: TextStyle(fontSize: 30),
            //////////Body//////////
            body: Container(
              padding: const EdgeInsets.all(20), //padding for the whole page
              child: Column(children: [
                Row(children: const [
                  Text("New Upload",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      )),
                ]),
                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        _captureImage().then((value) {
                          if (value != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        modal(result: value)));
                          }
                        });
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 58, 58, 58))),
                      child: const Icon(
                        FontAwesomeIcons.camera,
                        color: Colors.white,
                      ),
                    )),
                    const Padding(padding: EdgeInsets.all(10)),
                    //Makes button fill row
                    Expanded(
                        child: ElevatedButton.icon(
                            onPressed: () {
                              developer.log("Camera Button Pressed");
                              developer.log(_locationData.toString());
                              _pickfile().then((value) {
                                if (value != null) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              modal(result: value)));
                                }
                              });
                            },
                            icon: const Icon(FontAwesomeIcons.image,
                                color: Colors.white),
                            label: const Text("Upload",
                                style: TextStyle(color: Colors.white)),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<
                                        Color>(
                                    const Color.fromARGB(255, 58, 58, 58))))),
                  ],
                ),
                Row(children: widgetList),
              ]),
            )));
  }
}
