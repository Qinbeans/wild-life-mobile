import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:wild_life_mobile/ml/io.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'dart:developer' as developer;

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

  @override
  void initState() {
    super.initState();
    markers.clear();
    _getLocation();
    _locatonWork();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _locatonWork() async {
    final double long = _locationData == null
        ? 0.0
        : (_locationData!.longitude == null ? 0.0 : _locationData!.longitude!);
    final double lat = _locationData == null
        ? 0.0
        : (_locationData!.latitude == null ? 0.0 : _locationData!.latitude!);
    developer.log("Long: $long");
    developer.log("Lat: $lat");
    markers.add(Marker(
        point: LatLng(lat, long),
        builder: (context) => const FaIcon(FontAwesomeIcons.mapPin)));
    readJsonGPS().then((value) => {
          developer.log("Reading JSON GPS IN MAP"),
          developer.log("Value: $value"),
          markers.clear(),
          for (var i = 0; i < value.length; i++)
            {
              markers.add(Marker(
                  point: LatLng(value[i].latitude, value[i].longitude),
                  builder: (context) => const Icon(Icons.location_pin))),
            }
        });
  }

  void _getLocation() async {
    try {
      setState(() {});
      _locationData = await location.getLocation();
    } on PlatformException catch (_) {
      _locationData = LocationData.fromMap(<String, double>{
        'latitude': 0.0,
        'longitude': 0.0,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _getLocation();
    _locatonWork();
    setState(() {});
    return MaterialApp(
        home: Scaffold(
      backgroundColor: const Color.fromARGB(255, 37, 37, 37),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 37, 37, 37),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Map"),
        //titleTextStyle: TextStyle(fontSize: 30),
      ),
      body: Center(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: FlutterMap(
            options: MapOptions(
              center: LatLng(39.7285, -121.8375),
              zoom: 14,
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
