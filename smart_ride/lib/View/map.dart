import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../components/flutter_toast.dart';

class MapScreen extends StatefulWidget {
  final String mapid;
  const MapScreen({Key? key, required this.mapid});
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  List<LatLng> routePoints = [];
  List<LatLng> markerPositions = [];

  final firestoreInstance = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  List<Module> incidents = [];
  bool isLoading = true; // Add a loading state

  @override
  void initState() {
    super.initState();
    fetchModulesData();
  }

  Future<void> fetchModulesData() async {
    try {
      final snapshot = await firestoreInstance
          .collection("users")
          .doc(user!.uid)
          .collection("trips")
          .doc(widget.mapid)
          .collection("incident")
          .get();
      incidents = snapshot.docs.map((doc) {
        return Module(
          incidentId: doc.id,
          ridespeed: doc.get("speed").toDouble(),
          lat: doc.get("lat"),
          lot: doc.get("lot"),
        );
      }).toList();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      AppToastmsg.appToastMeassage("Error fetching modules data: $e");
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps'),
      ),
      body: Stack(
        children: [
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: incidents.isNotEmpty
                        ? LatLng(incidents[0].lat, incidents[0].lot)
                        : LatLng(6.9271, 79.8612),
                    zoom: 8,
                  ),
                  onMapCreated: (controller) {
                    mapController = controller;
                    setState(() {
                      for (int i = 0; i < markerPositions.length; i++) {
                        markers.add(
                          Marker(
                            markerId: MarkerId('Marker $i'),
                            position: markerPositions[i],
                          ),
                        );
                      }
                    });
                  },
                  markers: {
                    ...incidents.map((x) => Marker(
                        markerId: MarkerId(x.incidentId),
                        position: LatLng(x.lat, x.lot)))
                  },
                  polylines: Set<Polyline>.from([
                    Polyline(
                      polylineId: PolylineId('route'),
                      color: Colors.blue,
                      points: routePoints,
                    ),
                  ]),
                ),
        ],
      ),
    );
  }

  Future<List<LatLng>> getOptimizedRoute(List<LatLng> positions) async {
    const apiKey =
        'AIzaSyDT7jCpe-9ySSW5FCF8__5PFuvMMTx2asU'; // Replace with your API key
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${positions[0].latitude},${positions[0].longitude}&destination=${positions.last.latitude},${positions.last.longitude}&waypoints=${getWaypointsString(positions)}&key=$apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<LatLng> points = [];
      if (data['status'] == 'OK') {
        final List<dynamic> steps = data['routes'][0]['legs'][0]['steps'];
        for (int i = 0; i < steps.length; i++) {
          final startLatLng = LatLng(
            steps[i]['start_location']['lat'],
            steps[i]['start_location']['lng'],
          );
          points.add(startLatLng);
          if (i == steps.length - 1) {
            final endLatLng = LatLng(
              steps[i]['end_location']['lat'],
              steps[i]['end_location']['lng'],
            );
            points.add(endLatLng);
          }
        }
      }
      return points;
    } else {
      throw Exception('Failed to load route');
    }
  }

  String getWaypointsString(List<LatLng> positions) {
    final waypoints = positions.sublist(1, positions.length - 1);
    return waypoints
        .map((latLng) => 'via:${latLng.latitude},${latLng.longitude}')
        .join('|');
  }
}

class Module {
  final double ridespeed;
  final String incidentId;
  final double lat;
  final double lot;
  Module({
    required this.incidentId,
    required this.ridespeed,
    required this.lat,
    required this.lot,
  });
}
