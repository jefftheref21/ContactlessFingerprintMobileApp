import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fingerprint/pages/camera_page.dart';
import 'package:fingerprint/network_call.dart';

import 'package:fingerprint/models/user.dart';
import 'package:fingerprint/pages/enrollment_state_page.dart';
import 'package:fingerprint/constants.dart';

ImageIcon verificationIcon = const ImageIcon(AssetImage("assets/verification_icon.png"), color: MyColors.harrimanBlue,  size: 140);

class EnrollmentScanPage extends StatefulWidget {
  const EnrollmentScanPage({
    super.key,
    required this.uri,
    required this.user,
  });

  final String uri;
  final User user;

  @override
  State<EnrollmentScanPage> createState() => _EnrollmentScanPageState();
}

class _EnrollmentScanPageState extends State<EnrollmentScanPage>{
  bool firstScanComplete = false;
  bool secondScanComplete = false;

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
                  'Welcome ${widget.user.username},',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: MyColors.harrimanBlue
                  ),
                  textAlign: TextAlign.center,
                  // selectionColor: MyColors.harrimanBlue,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15.0, top: 30.0, right: 15.0),
              child: Text(
                'Scan your fingerprints to enroll.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: MyColors.harrimanBlue
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    widget.user.leftFingerprintPath = await Navigator.push(
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
                    widget.user.rightFingerprintPath = await Navigator.push(
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
                firstScanComplete ? Image.file(File(widget.user.leftFingerprintPath), width: 140, height: 140) : verificationIcon,
                const SizedBox(width: 40),
                secondScanComplete ? Image.file(File(widget.user.rightFingerprintPath), width: 140, height: 140) : verificationIcon,
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (firstScanComplete == false || secondScanComplete == false) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please complete both scans.'),
                    ),
                  );
                  return;
                }

                final result = await enrollUser(widget.uri, widget.user);

                if (result == 200) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return EnrollmentStatePage(user: widget.user);
                      },
                    ),
                  );
                }
                else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Enrollment failed.'),
                    ),
                  );
                }
              },
              child: const Text('Complete Enrollment'),
            ),
          ],
        ),
      ),
    );
  }
}