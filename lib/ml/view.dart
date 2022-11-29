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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Upload'),
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('Upload an image'),
            FormField(
              builder: (FormFieldState state) {
                return GestureDetector(onTap: () async {
                  //take in an image
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
                      : (_locationData!.longitude == null
                          ? 0.0
                          : _locationData!.longitude!);
                  final double lat = _locationData == null
                      ? 0.0
                      : (_locationData!.latitude == null
                          ? 0.0
                          : _locationData!.latitude!);
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
                });
              },
            )
          ]),
        ));
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
}
