//displays the ML page
//Find out whether there is network connection.
//If there is no network connection, use the local model.

//take in an image
import 'package:flutter/services.dart';

import '../model/image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'dart:convert';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

var isConnected = false;

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
  }

  void _refreshLocation() {
    setState((() {
      _checkLocationPermission();
    }));
  }

// FormField(
//   builder: (FormFieldState state) {
//     return GestureDetector(onTap: () async {
//       //take in an image
//
//     });
//   },
// ),

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
                    ])
                //titleTextStyle: TextStyle(fontSize: 30),
                ),
            body: Container(
              padding: const EdgeInsets.all(20),
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
                    const ElevatedButton(
                        onPressed: null,
                        child: Icon(
                          FontAwesomeIcons.camera,
                          color: Colors.white,
                        )),
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: _pickfile,
                        icon: const Icon(FontAwesomeIcons.image,
                            color: Colors.white),
                        label: const Text("Upload",
                            style: TextStyle(color: Colors.white))),
                  ],
                )
              ]),
            )));
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

  void _pickfile() async {
    _refreshLocation(); //update location
    final imagePicker = ImagePicker();
    final XFile? image =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
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
    } else {
      //send upload request to local model
    }
  }
}
