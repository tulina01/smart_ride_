import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:tuple/tuple.dart';

import '../components/flutter_toast.dart';
import '../components/riskcalc.dart';
import 'Evidence/Evidence.dart';
import 'map.dart';

class Triplist extends StatefulWidget {
  final String tripid;
  const Triplist({
    super.key,
    required this.tripid,
  });

  @override
  State<Triplist> createState() => _TriplistState();
}

class _TriplistState extends State<Triplist> {

  final firestoreInstance = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;
  double? from_lat;
  double? from_lot;
  double? to_lat;
  double? to_lot;

  bool isLoading = true;
  List<Module> trips = [];
  String Address = 'loading...';
  String Address2 = 'loading...';

  @override
  void initState() {
    super.initState();
    fetchModulesData2();
    getlocation2();
    
  }


  Future<void> fetchModulesData2() async {
    try {
      final snapshot = await firestoreInstance
          .collection("users")
          .doc(user!.uid)
          .collection("trips")
          .get();

      trips = snapshot.docs.map((doc) {
        return Module(
          tripID: doc.id,
          from_lat: doc.get("from_lat"),
          from_lot: doc.get("from_lot"),
          to_lat: doc.get("to_lat"),
          to_lot: doc.get("to_lot"),
        );
      }).toList();

        int extractTripNumber(String tripString) {
          if (tripString.startsWith("trip")) {
            String numericPart = tripString.substring("trip".length);
            return int.tryParse(numericPart) ?? -1;
          }
          return -1;
        }
        int tripNumber = extractTripNumber(widget.tripid!);
      setState(() {
      isLoading = false;
       from_lat = trips[tripNumber - 1].from_lat;
       from_lot = trips[tripNumber - 1].from_lot;
       to_lat = trips[tripNumber - 1].to_lat;
       to_lot = trips[tripNumber - 1].to_lot;
      });
    } catch (e) {
      AppToastmsg.appToastMeassage("Error fetching modules data: $e");
    }
  }

  Future<void> getlocation2() async{
    Position position = await _getGeoLocationPosition();
    GetAddressFromLatLong(position);
  }

  Future _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
            return Future.error('Location permissions are denied');
        }
    }

    if (permission == LocationPermission.deniedForever) {
        return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}

  Future GetAddressFromLatLong(Position position)async {
      List placemarks = await placemarkFromCoordinates(from_lat!, from_lot!);
      List placemarks2 = await placemarkFromCoordinates(to_lat!, to_lot!);
      Placemark place = placemarks[0];
      Placemark place2 = placemarks2[0];
      Address = '${place.locality}';
      Address2 = '${place2.locality}';
      setState(()  {
      });
  }

  @override
  Widget build(BuildContext context) {
    final firestoreInstance = FirebaseFirestore.instance;
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Last Trip/Dashboard'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: firestoreInstance
            .collection("users")
            .doc(user!.uid)
            .collection("trips")
            .doc(widget.tripid)
            .collection("incident")
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

  
          List<QueryDocumentSnapshot> incidentList = snapshot.data!.docs;
          int totalIncidents = incidentList.length;        
          double totalOverallRisk = RiskCalculator.calculateOverallRisk(incidentList);
          double minOverallRisk = RiskCalculator.calculateMinOverallRisk(incidentList);
          double maxOverallRisk = RiskCalculator.calculateMaxOverallRisk(incidentList);
          double averageRisk = totalIncidents > 0 ? totalOverallRisk / totalIncidents : 0.0;

       
          double maxAngleSpeed = RiskCalculator.maxAngleSpeed(incidentList);
          
          return Column(
            children: [
               Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  '$Address to $Address2',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              CircularPercentIndicator(
                radius: 70.0,
                lineWidth: 12.0,
                animation: true,
                percent: averageRisk / 100,
                center: Text(
                  "$averageRisk%",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                circularStrokeCap: CircularStrokeCap.butt,
                progressColor: Colors.blue,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircularPercentIndicator(
                    radius: 50.0,
                    lineWidth: 12.0,
                    animation: true,
                    percent: minOverallRisk / 100,
                    center: Text(
                      "$minOverallRisk%",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15.0),
                    ),
                    circularStrokeCap: CircularStrokeCap.butt,
                    progressColor: Colors.blue,
                    footer: const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        "Low Risk",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14.0),
                      ),
                    ),
                  ),
                  CircularPercentIndicator(
                    radius: 50.0,
                    lineWidth: 12.0,
                    animation: true,
                    percent: maxOverallRisk / 100,
                    center: Text(
                      "$maxOverallRisk%",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15.0),
                    ),
                    circularStrokeCap: CircularStrokeCap.butt,
                    progressColor: Colors.blue,
                    footer: const Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                        "High Risk",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14.0),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text("Risk Speed ${maxAngleSpeed}Kmh"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Evidence(
                                evidenceTrip: widget.tripid.toString()),
                          ),
                        );
                      },
                      child: const Text("Evidence")),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapScreen(mapid: widget.tripid),
                        ),
                      );
                    },
                    child: const Text("Map"),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: averageRisk > 50
                    ? const Text("Your ride is risky")
                    : const Text("Your ride is safe"),
              )
            ],
          );
        },
      ),
    );
  }

  double prerisk(int angle, double speed) {
    double speedRisk = calculateSpeedRisk(speed);
    double angleRisk = calculateAngleRisk(angle, speed);
    double overallRisk = (speedRisk + angleRisk) / 2;

    return overallRisk;
  }

  double calculateSpeedRisk(double speed) {
    if (speed <= 10) {
      return 0.0;
    } else if (speed <= 20) {
      return 20.0;
    } else if (speed <= 40) {
      return 40.0;
    } else if (speed <= 60) {
      return 60.0;
    } else if (speed <= 80) {
      return 80.0;
    } else {
      return 100.0;
    }
  }

  double calculateAngleRisk(int angle, double speed) {
    if (speed <= 10.0 && angle <= 2) {
      // Make sure to use 0.0 instead of 0
      return 0.0;
    } else if (speed <= 10.0 && angle <= 18) {
      // Make sure to use 0.0 instead of 0
      return 20.0;
    } else if (speed <= 10.0 && angle <= 36) {
      // Make sure to use 0.0 instead of 0
      return 40.0;
    } else if (speed <= 10.0 && angle <= 54) {
      // Make sure to use 0.0 instead of 0
      return 60.0;
    } else if (speed <= 10.0 && angle <= 72) {
      // Make sure to use 0.0 instead of 0
      return 80.0;
    } else if (speed <= 10.0) {
      return 0.0;
    } else {
      return 100.0;
    }
  }
}


class Module {
  final String tripID;
  final double from_lat;
  final double from_lot;
  final double to_lat;
  final double to_lot;

  Module({
    required this.tripID,
    required this.from_lat,
    required this.from_lot,
    required this.to_lat,
    required this.to_lot,
  });
}
