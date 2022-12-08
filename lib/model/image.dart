import 'package:wild_life_mobile/ml/detection.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:developer' as developer;

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
  String data = '';
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

class FullResult {
  String data = '';
  List<Detection> detections = [];
  bool local = false;

  FullResult({
    required this.data,
    required this.detections,
    required this.local,
  });

  String getName() {
    return basename(File(data).path);
  }

  Results? toResults() {
    //find the highest confidence detection
    Detection? detection;
    for (var d in detections) {
      if (detection == null) {
        detection = d;
      } else {
        if (d.confidence > detection.confidence) {
          detection = d;
        }
      }
    }
    if (detection == null) {
      return null;
    }
    return Results(
      data: data,
      confidence: detection.confidence,
      local: local,
    );
  }
}

class Results {
  String data = ''; //if local, this will be a path
  double confidence = 0.0;
  bool local = false;
  Results({
    required this.data,
    required this.confidence,
    required this.local,
  });

  Results fromJson(Map<String, dynamic> json) {
    return Results(
      data: json['data'],
      confidence: json['confidence'],
      local: json['local'],
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data,
        'confidence': confidence,
        'local': local,
      };
}
