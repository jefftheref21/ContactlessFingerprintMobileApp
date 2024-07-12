import 'package:flutter/material.dart';

import 'package:fingerprint/pages/enrollment_page.dart';
import 'package:fingerprint/pages/verification_page.dart';
import 'package:fingerprint/pages/identification_page.dart';
import 'package:fingerprint/constants.dart';


String baseUrl = "http://10.0.2.2:5000";

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int tab = 0;
  List<BottomNavigationBarItem> appBarDestinations = [
    const BottomNavigationBarItem(
      icon: ImageIcon(AssetImage("assets/enrollment_icon.png"), color: MyColors.victorEBlue,  size: 40),
      label: 'Enrollment',
    ),
    const BottomNavigationBarItem(
      icon: ImageIcon(AssetImage("assets/verification_icon.png"), color: MyColors.victorEBlue, size: 40),
      label: 'Verification',
    ),
    const BottomNavigationBarItem(
      icon: ImageIcon(AssetImage("assets/identification_icon.png"), color: MyColors.victorEBlue, size: 40),
      label: 'Identification',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final List pages = [
      {"page": EnrollmentPage(url: "$baseUrl/enrollment"), "title": "Enrollment"},
      {"page": VerificationPage(url: "$baseUrl/verification"), "title": "Verification"},
      {"page": IdentificationPage(), "title": "Identification"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(pages[tab]["title"]),
        centerTitle: true,
      ),
      body: pages[tab]["page"],
      // Set the bottom navigation bar.
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tab,
        onTap: (int index) {
          setState(() {
            tab = index;
          });
        },
        items: appBarDestinations
      ),
    );
  }
}