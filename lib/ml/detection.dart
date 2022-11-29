//object for detection
class Box {
  double _x = 0;
  double _y = 0;
  double _width = 0;
  double _height = 0;
  //constructor
  Box(this._x, this._y, this._width, this._height);
  //getters
  double get x => _x;
  double get y => _y;
  double get w => _width;
  double get h => _height;
  //printable
  @override
  String toString() {
    return 'Box: [x: $_x, y: $_y, w: $_width, h: $_height]';
  }
}

class Detection {
  Box _box;
  double _confidence = 0;
  String _label = "";
  //constructor
  Detection(this._box, this._confidence, this._label);
  //getters
  Box get box => _box;
  double get confidence => _confidence;
  String get label => _label;
  //printable
  @override
  String toString() {
    return 'Detection: [box: $_box, confidence: $_confidence, label: $_label]';
  }
}
