//processes incoming images
import 'package:pytorch_mobile/pytorch_mobile.dart';
import 'package:pytorch_mobile/model.dart';
import 'package:image/image.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Model? model;

const int size = 256;

//Initialize the model
void initModel() async {
  model = await PyTorchMobile.loadModel(join('assets', 'model.pt'));
}

//Format image for processing
Future<File> formatImage(File image) async {
  //resize image to fit 256x256
  Image resizedImage = decodeImage(image.readAsBytesSync())!;
  resizedImage = copyResize(resizedImage, width: size, height: size);
  //convert image bytes into file
  String tempPath = (await getTemporaryDirectory()).path;
  File tempFile = File('$tempPath/temp.jpg');
  tempFile.writeAsBytesSync(encodeJpg(resizedImage));
  return tempFile;
}

//Process image and return predictions
Future<List<double>> processImage(File image) async {
  //processes image
  File fixed = await formatImage(image);
  List<double> output = List<double>.filled(0, 0);
  List<dynamic>? raw;
  if (model == null) {
    initModel();
    //attempt to load model, else return empty list
    if (model == null) {
      return output;
    }
  }
  //process image
  raw = await model!.getImagePredictionList(fixed, size, size);
  if (raw == null) {
    return output;
  }
  //parse output
  for (int i = 0; i < raw.length; i++) {
    output.add(raw[i]);
  }
  //must debug to find sizes of output
  return output;
}
