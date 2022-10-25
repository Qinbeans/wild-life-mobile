import 'package:flutter/foundation.dart';

class GPS {
  final double latitude;
  final double longitude;

  GPS({
    required this.latitude,
    required this.longitude,
  });
}

//image data
class UploadRequest {
  String name = '';
  String type = '';
  GPS location = GPS(latitude: 0.0, longitude: 0.0);
  //unsigned int
  int size = 0;
  //array of bytes
  Uint8List data = Uint8List(0);
  UploadRequest({
    required this.name,
    required this.type,
    required this.location,
    required this.size,
    required this.data,
  });
}

class ResponseData {
  String name = '';
  int size = 0;
  String token = '';
  ResponseData({
    required this.name,
    required this.size,
    required this.token,
  });
}

class UploadResponse {
  bool success = false;
  String message = '';
  ResponseData? data;
  UploadResponse({
    required this.success,
    required this.message,
    this.data,
  });
}
