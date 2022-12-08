import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:wild_life_mobile/ml/io.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';

List<Marker> markers = [];

//Dispaly map and relevant map data
class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  Location location = Location();
  LocationData? _locationData;
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    markers.add(Marker(
        point: LatLng(38.7285, -121.8375),
        builder: (ctx) {
          return const Icon(Icons.location_on);
        }));
    // readJson().then((value) => {
    //       for (var i = 0; i < history.length; i++)
    //         {
    //           //grab the image from the path
    //           widgetList.add(UploadResultState(
    //               confidence: history[i].confidence, imageName: imageName)),
    //         }
    //     });
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      backgroundColor: const Color.fromARGB(255, 37, 37, 37),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 37, 37, 37),
        //leadingWidth: 20,
        //centerTitle: true,
        //title: const Text('Wildlife'),+
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Map"),
        //titleTextStyle: TextStyle(fontSize: 30),
      ),
      //////////Body//////////
      body: Center(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: FlutterMap(
            options: MapOptions(
              center: LatLng(39.7285, -121.8375),
              zoom: 7,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'dev.fleaflet.flutter_map.example',
              ),
              MarkerLayer(
                markers: markers,
              )
            ],
          ),
        ),
      ),
    ));
  }
}
