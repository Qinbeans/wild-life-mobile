import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:wild_life_mobile/model/image.dart';

//writes a list of objects into a json file
void writeJson(List<Results> list) async {
  var json = jsonEncode(list);
  //write to file
  final directory = await getApplicationDocumentsDirectory();
  final file = File(join(directory.path, 'results.json'));
  await file.writeAsString(json);
}

void writeJsonGPS(List<GPS> list) async {
  var json = jsonEncode(list);
  //write to file
  final directory = await getApplicationDocumentsDirectory();
  final file = File(join(directory.path, 'gps.json'));
  await file.writeAsString(json);
}

Future<List<GPS>> readJsonGPS() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File(join(directory.path, 'gps.json'));
  //check if file exists
  if (await file.exists()) {
    final json = file.readAsStringSync();
    final list = jsonDecode(json);
    return list;
  }
  return [];
}

//reads a json file and returns a list of objects
Future<List<Results>> readJson() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File(join(directory.path, 'results.json'));
  //check if file exists
  if (await file.exists()) {
    final json = file.readAsStringSync();
    final list = jsonDecode(json);
    return list;
  }
  return [];
}

void deleteJson() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File(join(directory.path, 'results.json'));

  if (await file.exists()) {
    await file.delete();
  }
}
