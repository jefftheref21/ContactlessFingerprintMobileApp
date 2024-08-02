import 'package:fingerprint/network_call.dart';
import 'package:fingerprint/pages/verification_results_page.dart';
import 'package:flutter/material.dart';
import 'package:fingerprint/constants.dart';
import 'package:fingerprint/pages/camera_page.dart';
import 'package:fingerprint/models/user.dart';
import 'package:fingerprint/pages/loading_page.dart';

import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

class VerificationScanPage extends StatefulWidget {
  const VerificationScanPage({
    super.key,
    required this.uri,
    required this.user,
  });

  final String uri;
  final User user;

  @override
  State<VerificationScanPage> createState() => _VerificationScanPageState();
}

class _VerificationScanPageState extends State<VerificationScanPage> {
  late bool firstScanComplete;
  late bool secondScanComplete;
  late String enrolled1;
  late String enrolled2;

  @override
  void initState() {
    super.initState();
    firstScanComplete = false;
    secondScanComplete = false;
    enrolled1 = widget.user.leftFingerprintPath;
    enrolled2 = widget.user.rightFingerprintPath;
    widget.user.leftFingerprintPath = '';
    widget.user.rightFingerprintPath = '';
  }

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
                    widget.user.leftFingerprintPath = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return const CameraPage(
                            title: "First Scan",
                            leftSide: true,
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
                firstScanComplete ? Image.file(File(widget.user.leftFingerprintPath), width: 140, height: 140) : MyIcons.verificationIcon,
                const SizedBox(width: 40),
                secondScanComplete ? Image.file(File(widget.user.rightFingerprintPath), width: 140, height: 140) : MyIcons.verificationIcon,
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

                Navigator.push(context, MaterialPageRoute(builder: (context) => const LoadingPage()));

                print(widget.user.leftFingerprintPath);

                final response = await verifyFingerprints(widget.uri, widget.user, enrolled1, enrolled2);

                if (!context.mounted) return;
                Navigator.pop(context);

                if (response.statusCode != 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Verification failed.'),
                      ),
                    );
                  return;
                }

                final responseBody = await response.stream.bytesToString();
                final result = json.decode(responseBody);

                var leftScore = result['left_score'];
                var rightScore = result['right_score'];
                var leftPred = result['left_pred'];
                var rightPred = result['right_pred'];
                var leftSimList = result['left_sim_list'];
                var rightSimList = result['right_sim_list'];
                // final String leftBbox1 = result['left_bbox1'];
                // final String rightBbox1 = result['right_bbox1'];
                // final String leftBbox2 = result['left_bbox2'];
                // final String rightBbox2 = result['right_bbox2'];

                // Uint8List? _imageBytes1;
                // _imageBytes1 = base64Decode(leftBbox1);
                // Uint8List? _imageBytes2;
                // _imageBytes2 = base64Decode(rightBbox1);
                // Uint8List? _imageBytes3;
                // _imageBytes3 = base64Decode(leftBbox2);
                // Uint8List? _imageBytes4;
                // _imageBytes4 = base64Decode(rightBbox2);

                leftScore = double.parse(leftScore.toStringAsFixed(4));
                rightScore = double.parse(rightScore.toStringAsFixed(4));
                for (var i = 0; i < 4; i++) {
                  leftSimList[i] = double.parse(leftSimList[i].toStringAsFixed(4));
                  rightSimList[i] = double.parse(rightSimList[i].toStringAsFixed(4));
                }

                if (!context.mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VerificationResultsPage(
                      user: widget.user,
                      leftScore: leftScore,
                      rightScore: rightScore,
                      leftPred: leftPred,
                      rightPred: rightPred,
                      leftSimList: leftSimList,
                      rightSimList: rightSimList,
                      // leftBbox1: _imageBytes1,
                      // rightBbox1: _imageBytes2,
                      // leftBbox2: _imageBytes3,
                      // rightBbox2: _imageBytes4,
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