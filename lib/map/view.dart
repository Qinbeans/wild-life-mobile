import 'package:flutter/material.dart';

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
            body: Container(
              padding: const EdgeInsets.all(20), //padding for the whole page
            )));
  }
}
