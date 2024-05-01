import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:location/location.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late latLng.LatLng currentLocation;
  late Location location;

  @override
  void initState() {
    super.initState();
    location = Location();
    currentLocation = latLng.LatLng(12.8797, 121.7740);
  }

  void updateLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print('Location permissions are denied.');
        return;
      }
    }

    try {
      final LocationData locData = await location.getLocation();
      print("Location retrieved: ${locData.latitude}, ${locData.longitude}");
      setState(() {
        currentLocation = latLng.LatLng(locData.latitude!, locData.longitude!);
      });
    } catch (e) {
      print("Could not get the location: $e");
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 400,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: currentLocation,
                initialZoom: 6.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://api.mapbox.com/styles/v1/haroldrhey/clvnj1oma01bz01q1c1udhf13/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiaGFyb2xkcmhleSIsImEiOiJjbHJza3Z5enAwODg5MmpwMXQ3OG00OWM4In0.cn27HrW09A8pKZMx-r0FSw',
                  additionalOptions: {
                    'accessToken' : 'pk.eyJ1IjoiaGFyb2xkcmhleSIsImEiOiJjbHJza3Z5enAwODg5MmpwMXQ3OG00OWM4In0.cn27HrW09A8pKZMx-r0FSw',
                    'id' : 'mapbox.mapbox-streets-v8'
                  },
                ),
              ],
            )
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              print("Button pressed");
              updateLocation();
            },
            child: Text("Show My Location"),
          )
        ],
      )
    );
  }
}
