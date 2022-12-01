import '../model/image.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

//writes a list of objects into a json file
void writeJson(List<Results> list) async {
  var json = jsonEncode(list);
  //write to file
  final directory = await getApplicationDocumentsDirectory();
  final file = File(join(directory.path, 'results.json'));
  await file.writeAsString(json);
}

//reads a json file and returns a list of objects
Future<List<Results>> readJson() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File(join(directory.path, 'results.json'));
  final json = file.readAsStringSync();
  final list = jsonDecode(json);
  return list;
}
