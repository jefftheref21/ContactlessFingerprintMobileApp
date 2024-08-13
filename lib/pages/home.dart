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
  
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _selectedTab = 0;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      EnrollmentPage(uri: "$baseUri/enrollment", title: "Enrollment"),
      VerificationPage(uri: "$baseUri/verification", title: "Verification"),
      IdentificationPage(uri: "$baseUri/identification", title: "Identification"),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text((pages[_selectedTab] as dynamic).title),
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
            _pageController.animateToPage(tab, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
          });
        },
        items: appBarDestinations
      ),  
    );
  }
}
