import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'history.dart';
import 'lasttrip.dart';
import 'loyality.view.dart';
import 'setting.dart';
import 'static.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final itemTexts = [
    'Last Trip',
    'History',
    'Static',
    'Loyalty Point',
    'Settings',
    'Log out',
  ];

  final icons = [
    Icons.trip_origin,
    Icons.history,
    Icons.bar_chart,
    Icons.star,
    Icons.settings,
    Icons.logout,
  ];

  final pages = [
    LastTrip(), // Replace with actual pages or routes
    History(),
    StaticChart(),
    LoyalityView(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: itemTexts.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (index == 5) {
                  // Log out action
                  _performLogout(context);
                } else {
                  // Navigate to other pages
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => pages[index]),
                  );
                }
              },
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icons[index],
                      size: 48,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      itemTexts[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    // Perform the refresh logic here
  }

  void _performLogout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to the login screen or any other appropriate screen
      // after successful sign-out.
    } catch (e) {
      print("Error signing out: $e");
    }
  }
}