import 'package:flutter/material.dart';

import 'package:fingerprint/pages/enrollment_page.dart';
import 'package:fingerprint/pages/verification_page.dart';
import 'package:fingerprint/pages/identification_page.dart';
import 'package:fingerprint/constants.dart';


// String baseUri = "http://192.168.0.22:5000";
String baseUri = "http://128.205.33.222:5000";

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late PageController _pageController;
  late int _selectedTab;
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
  // Add animations between different pages

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _selectedTab = 0;
  }

  @override
  Widget build(BuildContext context) {
    // final List pages = [
    //   {"page": EnrollmentPage(uri: "$baseUri/enrollment"), "title": "Enrollment"},
    //   {"page": VerificationPage(uri: "$baseUri/verification"), "title": "Verification"},
    //   {"page": IdentificationPage(uri: "$baseUri/identification"), "title": "Identification"},
    // ];

    List<Widget> pages = [
      EnrollmentPage(uri: "$baseUri/enrollment", title: "Enrollment"),
      VerificationPage(uri: "$baseUri/verification"),
      IdentificationPage(uri: "$baseUri/identification"),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(pages[_selectedTab].getTitle()),
        centerTitle: true,
        
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (int tab) {
          setState(() => _selectedTab = tab);
        },
        children: pages,
      ),
      // Set the bottom navigation bar.
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (int tab) {
          setState(() {
            _selectedTab = tab;
            _pageController.animateToPage(tab, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
          });
        },
        items: appBarDestinations
      ),  
    );
  }
}
