// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'triplist.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final firestoreInstance = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  List<Module> trips = [];
  bool isLoading = true;
  double? from_lat;
  double? from_lot;
  double? to_lat;
  double? to_lot;
  String Address = 'loading...';
  String Address2 = 'loading...';
  List<String> fromAddresses = [];
  List<String> toAddresses = [];

  @override
  void initState() {
    super.initState();
    fetchAddressesForTrips();
    fetchModulesData();
  }

  Future<void> fetchModulesData() async {
    try {
      final snapshot = await firestoreInstance
          .collection("users")
          .doc(user!.uid)
          .collection("trips")
          .orderBy("date", descending: true)
          .get();

      trips = snapshot.docs.map((doc) {
        Timestamp timestamp = doc.get("date");
        DateTime dateTime = timestamp.toDate();
        return Module(
          tripID: doc.id,
          date: dateTime,
          from_lat: doc.get("from_lat"),
          from_lot: doc.get("from_lot"),
          to_lat: doc.get("to_lat"),
          to_lot: doc.get("to_lot"),
        );
      }).toList();

      await fetchAddressesForTrips();
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      AppToastmsg.appToastMeassage("Error fetching modules data: $e");
    }
  }

  Future<void> fetchAddressesForTrips() async {
    for (int i = 0; i < trips.length; i++) {
      double fromLat = trips[i].from_lat;
      double fromLon = trips[i].from_lot;
      double toLat = trips[i].to_lat;
      double toLon = trips[i].to_lot;

      Placemark fromPlace =
          (await placemarkFromCoordinates(fromLat, fromLon))[0];
      Placemark toPlace = (await placemarkFromCoordinates(toLat, toLon))[0];

      setState(() {
        fromAddresses.add(fromPlace.locality!);
        toAddresses.add(toPlace.locality!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : trips.isEmpty
              ? const Center(
                  child: Text('No trips available.'),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              const SizedBox(height: 100),
                              Container(
                                width: 13,
                                height: 13,
                                color: Colors.red,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text("High risk"),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                width: 13,
                                height: 13,
                                color: Colors.yellow,
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text("Low risk"),
                              )
                            ],
                          ),
                        ],
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: trips.length,
                        itemBuilder: (context, index) {
                          String formattedDate = DateFormat('yyyy-MM-dd')
                              .format(trips[index].date);

                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        width: 1.0, color: Colors.grey)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              border: Border.all(
                                                  width: 1.0,
                                                  color: Colors.grey)),
                                          child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Align(
                                                alignment: Alignment.center,
                                                child: Text('0' +
                                                    (index + 1).toString())),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              formattedDate,
                                              style:
                                                  const TextStyle(fontSize: 15),
                                            ),
                                            Text(
                                              '${fromAddresses[index]} to ${toAddresses[index]}',
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        CircularPercentIndicator(
                                          radius: 25.0,
                                          lineWidth: 7.0,
                                          animation: true,
                                          percent: 0.7,
                                          circularStrokeCap:
                                              CircularStrokeCap.round,
                                          progressColor: Colors.red,
                                          backgroundColor: Colors.yellow,
                                        ),
                                        const SizedBox(height: 5),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Triplist(
                                                    tripid:
                                                        trips[index].tripID),
                                              ),
                                            );
                                          },
                                          child: const Text("See more"),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10)
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}

class Module {
  final String tripID;
  final DateTime date;
  final double from_lat;
  final double from_lot;
  final double to_lat;
  final double to_lot;

  Module({
    required this.tripID,
    required this.date,
    required this.from_lat,
    required this.from_lot,
    required this.to_lat,
    required this.to_lot,
  });
}

class AppToastmsg {
  static void appToastMeassage(String message) {
    // Implement your toast logic
  }
}
