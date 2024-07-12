import 'package:fingerprint/pages/verification_results_page.dart';
import 'package:flutter/material.dart';
import 'package:fingerprint/constants.dart';
import 'package:fingerprint/pages/camera_page.dart';
import 'package:fingerprint/models/user.dart';

import 'dart:io';

ImageIcon verificationIcon = const ImageIcon(AssetImage("assets/verification_icon.png"), color: MyColors.harrimanBlue,  size: 140);

class VerificationScanPage extends StatefulWidget {
  const VerificationScanPage({
    super.key,
    required this.user,
  });

  final User user;

  @override
  State<VerificationScanPage> createState() => _VerificationScanPageState();
}

class _VerificationScanPageState extends State<VerificationScanPage> {
  bool firstScanComplete = false;
  bool secondScanComplete = false;
  String leftFingerprintPath = '';
  String rightFingerprintPath = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fingerprint Scan'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 30.0),
                child: Text(
                  'Welcome back ${widget.user.username},',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: MyColors.harrimanBlue
                  ),
                  textAlign: TextAlign.center,
                  // selectionColor: MyColors.harrimanBlue,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Scan your fingerprints to verify.',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: MyColors.harrimanBlue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    leftFingerprintPath = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const CameraPage(
                            title: "First Scan",
                          );
                        },
                      ),
                    );
                    setState(() {
                      firstScanComplete = true;
                    });
                  },
                  child: const Text('First Scan'),
                ),
                const SizedBox(width: 40),
                ElevatedButton(
                  onPressed: () async {
                    rightFingerprintPath = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const CameraPage(
                            title: "Second Scan",
                            leftSide: false,
                            );
                        },
                      ),
                    );
                    setState(() {
                      secondScanComplete = true;
                    });
                  },
                  child: const Text('Second Scan'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                firstScanComplete ? Image.file(File(leftFingerprintPath), width: 140, height: 140) : verificationIcon,
                const SizedBox(width: 40),
                secondScanComplete ? Image.file(File(rightFingerprintPath), width: 140, height: 140) : verificationIcon,
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (firstScanComplete == false || secondScanComplete == false) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please complete both scans.'),
                    ),
                  );
                  return;
                }
                widget.user.leftFingerprintPath = leftFingerprintPath;
                widget.user.rightFingerprintPath = rightFingerprintPath;
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VerificationResultsPage(
                      user: widget.user,
                    ),
                  ),
                );
              },
              child: const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}