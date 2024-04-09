import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../components/flutter_toast.dart';
import '../components/linechart.dart';

class LoyalityView extends StatefulWidget {
  const LoyalityView({super.key});

  @override
  State<LoyalityView> createState() => _LoyalityViewState();
}

class _LoyalityViewState extends State<LoyalityView> {
  bool isValidForm = false;
  final _formKey = GlobalKey<FormState>();
  int points = 0;

  int withdrawValue = 0;

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    getUserData();
    fetchPoints();
  }

  Future<void> getUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      Map<String, dynamic>? fetchedUserData = await fetchUserData(currentUser);
      setState(() {
        userData = fetchedUserData;
      });
    }
  }

  Future<Map<String, dynamic>?> fetchUserData(User user) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userData = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userData.exists) {
        return userData.data();
      } else {
        AppToastmsg.appToastMeassage('User data not found in Firestore');
        return null;
      }
    } catch (e) {
      AppToastmsg.appToastMeassage('Failed to fetch user data: $e');

      return null;
    }
  }

  Future<void> fetchPoints() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> pointsSnapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(currentUser.uid)
                .collection('points')
                .doc('PsVVqV0JVqqz79HI8KBf')
                .get();

        if (pointsSnapshot.exists) {
          setState(() {
            points = (pointsSnapshot.data()?['myvalue'] ?? "Value not found");
          });
        } else {}
        // ignore: empty_catches
      } catch (e) {}
    }
  }

  Future<void> updatePoints(int incVal) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        final DocumentReference pointsDocRef = FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .collection('points')
            .doc('PsVVqV0JVqqz79HI8KBf');
        await pointsDocRef.update({'myvalue': FieldValue.increment(incVal)});
        fetchPoints();
      } catch (e) {
        print('Failed to update points: $e');
      }
    }
  }

  void incrementQuantity(int incVal) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    try {
      final DocumentReference itemRef = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .collection('points')
          .doc('PsVVqV0JVqqz79HI8KBf');
      await itemRef.update({'myvalue': FieldValue.increment(incVal)});
      fetchPoints();
      appToastMeassage('Points withdrawal is successful');
    } catch (e) {
      print('Failed to update points: $e');
    }
  }

  appToastMeassage(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }

  int calculatePoints(double riskPercentage) {
    if (riskPercentage == 0) {
      return 50;
    } else if (riskPercentage <= 10) {
      return 40;
    } else if (riskPercentage <= 20) {
      return 30;
    } else if (riskPercentage <= 30) {
      return 20;
    } else if (riskPercentage <= 40) {
      return 10;
    } else if (riskPercentage == 50) {
      return 5;
    } else if (riskPercentage == 60) {
      return -10;
    } else if (riskPercentage == 70) {
      return -20;
    } else if (riskPercentage == 80) {
      return -30;
    } else if (riskPercentage == 90) {
      return -40;
    } else if (riskPercentage == 100) {
      return -50;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    String userName = userData?['username'] ?? 'N/A';
    String email = userData?['email'] ?? 'N/A';
    String address = userData?['address'] ?? 'N/A';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Loyality Point'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Row(
                  children: [
                    const Icon(
                      Icons.person_outline,
                      color: Colors.blue,
                      size: 100,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              userName,
                              style: const TextStyle(),
                            ),
                            const Icon(
                              Icons.beenhere,
                              color: Colors.blue,
                            )
                          ],
                        ),
                        Text(
                          email,
                          style: const TextStyle(),
                        ),
                        Text(
                          address,
                          style: const TextStyle(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 1.0, color: Colors.grey)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(points.toString()),
                              const Text("Points"),
                            ],
                          ),
                          const Row(
                            children: [
                              Icon(Icons.star, color: Colors.yellow),
                              Icon(Icons.star, color: Colors.yellow),
                              Icon(Icons.star),
                              Icon(Icons.star),
                              Icon(Icons.star),
                            ],
                          )
                        ],
                      ),
                      const Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.yellow),
                              Text("200 star")
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                              hintText: "Enter Mobile Number"),
                          validator: (inputValue) {
                            if (inputValue!.isEmpty) {
                              return "Please enter";
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          enabled: false,
                          decoration: InputDecoration(
                            labelText: withdrawValue.toString(),
                          ),
                          validator: (inputValue) {
                            if (inputValue!.isEmpty) {
                              return "Please Fill";
                            }
                            return null;
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                withdrawValue = 20;
                              });
                            },
                            child: const Text("20"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                withdrawValue = 50;
                              });
                            },
                            child: const Text("50"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                withdrawValue = 100;
                              });
                            },
                            child: const Text("100"),
                          ),
                        ],
                      ),
                      ElevatedButton(
                          onPressed: () {
                            incrementQuantity(-withdrawValue);
                          },
                          child: const Text("Withdraw")),
                    ],
                  )),
              const LineChartSample2()
            ],
          ),
        ),
      ),
    );
  }
}