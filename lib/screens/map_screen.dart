import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../model/map_style.dart';



class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPagesState();
}

class _MapPagesState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  final Location location = Location();


  LocationData? currentLocation; //to store location
  BitmapDescriptor? customMarker;
  BitmapDescriptor? friendMarker;


  final List<Map<String, dynamic>> friends = [
    {'id': 'friend1', 'name': 'Alice', 'latitude': 44.2330, 'longitude': -76.4942}, // Example coordinates
    {'id': 'friend2', 'name': 'Bob', 'latitude': 44.2398, 'longitude': -76.4961},
  ];

  @override
  void initState() {
    super.initState();
    getLocationPermission();
    loadCustomMarker();
    loadFriendMarker();
  }

  // Load custom markers for user and friends
  // Load custom marker for the user
  void loadCustomMarker() {
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      'assets/images/myMarker.png',
    ).then((icon) {
      setState(() {
        customMarker = icon;
      });
    });
  }

  // Load custom marker for friends
  void loadFriendMarker() {
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      'assets/images/marker-5.png', // Make sure this path is correct
    ).then((icon) {
      setState(() {
        friendMarker = icon;
      });
    });
  }

  Future<void> getLocationPermission() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Check if location service is enabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    // Check location permissions
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    // Get current location
    final loc = await location.getLocation();
    setState(() {
      currentLocation = loc;
    });

    // Listen for location changes
    location.onLocationChanged.listen((LocationData newLocation) {
      setState(() {
        currentLocation = newLocation;
      });
    });
  }


  // Create markers for friends
  Set<Marker> _createFriendMarkers() {
    // Check if friendMarker is null before creating friend markers
    if (friendMarker == null) {
      return {}; // Return an empty set if friendMarker is not initialized yet
    }

    return friends.map((friend) {
      return Marker(
        markerId: MarkerId(friend['id']),
        position: LatLng(friend['latitude'], friend['longitude']),
        icon: friendMarker!,
        infoWindow: InfoWindow(
          title: friend['name'],
          snippet: 'Friend\'s location',
        ),
      );
    }).toSet();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentLocation == null
      ? const Center(child: CircularProgressIndicator(),)
      : GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
            zoom: 17.5,
        ),


        markers: {
          Marker(
            markerId: const MarkerId("source"),
            position: LatLng(
                currentLocation!.latitude!,
                currentLocation!.longitude!
            ),
            icon: customMarker!, // Use custom marker here
            infoWindow: InfoWindow(
              title: "you",
              snippet: 'Your current location',
            ),
          ),

          ..._createFriendMarkers(),
        },


        onLongPress: (LatLng latLng) {

        },

        onTap: (LatLng latLng) {


        },
        onMapCreated: (GoogleMapController controller) async {
          _controller.complete(controller);
          final mapController = await _controller.future;
          try {
            mapController.setMapStyle(MapStyle().dark);
          }catch (e){
            print('fail');
          }
        },
      ),
    );
  }

}