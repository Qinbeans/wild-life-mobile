import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:wild_life_mobile/model/image.dart';
import 'dart:developer' as developer;

//writes a list of objects into a json file
void writeJson(Results list) async {
  //write to file
  final directory = await getApplicationDocumentsDirectory();
  final file = File(join(directory.path, 'results.json'));
  //print list
  var json = jsonEncode(list);
  developer.log(json);
  await file.writeAsString(json, mode: FileMode.append);
}

//reads a json file and returns a list of objects
Future<List<Results>> readJson() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File(join(directory.path, 'results.json'));
  //check if file exists
  if (await file.exists()) {
    developer.log("Reading list from JSON");
    var json = file.readAsStringSync();
    json = '[$json]';
    developer.log(json);
    json = json.replaceAll('}{', '},{');
    //var json2 = jsonDecode(json);
    //developer.log(json2);
    final resulting = Results(data: '', confidence: 0.0, local: true);
    List<Results> list = [];
    list.addAll(
        List<Results>.from(jsonDecode(json).map((x) => resulting.fromJson(x))));
    return list;
  }
  return [];
}

void writeJsonGPS(GPS list) async {
  developer.log("Writing list to JSON GPS");
  var json = jsonEncode(list);
  //developer.log(list.toString());
  //write to file
  final directory = await getApplicationDocumentsDirectory();
  final file = File(join(directory.path, 'gps.json'));
  await file.writeAsString(json, mode: FileMode.append);
}

Future<List<GPS>> readJsonGPS() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File(join(directory.path, 'gps.json'));
  //check if file exists
  if (await file.exists()) {
    developer.log("Reading list from JSON GPS");
    var json = file.readAsStringSync();
    json = '[$json]';
    developer.log(json);
    json = json.replaceAll('}{', '},{');
    final gps = GPS(latitude: 0.0, longitude: 0.0);
    List<GPS> list = [];
    list.addAll(List<GPS>.from(jsonDecode(json).map((x) => gps.fromJson(x))));
    developer.log("Returning JSON GPS");

    return list;
  }
  return [];
}

void deleteJson() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File(join(directory.path, 'results.json'));

  if (await file.exists()) {
    developer.log("Deleting JSON");
    await file.delete();
  }
}

void deleteJsonGPS() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File(join(directory.path, 'gps.json'));

  if (await file.exists()) {
    developer.log("Deleting JSON GPS");
    await file.delete();
  }
}
