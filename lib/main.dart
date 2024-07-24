import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:fingerprint/pages/home.dart';
import 'package:fingerprint/constants.dart';
import 'package:flutter/services.dart';

List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  cameras = await availableCameras();

  runApp(const Biometrics());
}

class Biometrics extends StatelessWidget {
  const Biometrics({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Biometrics',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          elevation: 2,
          backgroundColor: MyColors.ubBlue,
          titleTextStyle: TextStyle(
            color: MyColors.hayesHallWhite,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: MyColors.ubBlue,
          unselectedLabelColor: MyColors.hayesHallWhite,
          
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: MyColors.ubBlue),
        scaffoldBackgroundColor: MyColors.victorEBlue,
        //primarySwatch: Colors.blue,
        // visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      home: Home(),
    );
  }
}
