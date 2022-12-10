import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:wild_life_mobile/ml/io.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
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
    // for (int i = 0; i < markers.length; i++) {
    //   markers.removeAt(i);
    // }
    readJsonGPS().then((value) => {
          developer.log("Reading JSON GPS IN MAP"),
          for (var i = 0; i < value.length; i++)
            {
              //grab the image from the path
              developer.log(value[i].latitude.toString()),
              markers.add(Marker(
                  point: LatLng(value[i].latitude, value[i].longitude),
                  builder: (context) => const Icon(Icons.location_pin))),
            }
        });
  }

  @override
  Widget build(BuildContext context) {
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
