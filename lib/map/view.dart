import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

//Dispaly map and relevant map data
class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  MapPageState createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
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
            ],
          ),
        ),
      ),
    ));
  }
}
