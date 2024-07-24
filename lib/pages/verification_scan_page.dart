import 'package:fingerprint/network_call.dart';
import 'package:fingerprint/pages/verification_results_page.dart';
import 'package:flutter/material.dart';
import 'package:fingerprint/constants.dart';
import 'package:fingerprint/pages/camera_page.dart';
import 'package:fingerprint/models/user.dart';

import 'dart:io';
import 'dart:convert';

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

                print(widget.user.leftFingerprintPath);

                final response = await verifyFingerprints(widget.uri, widget.user, enrolled1, enrolled2);

                if (response.statusCode != 200) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Verification failed.'),
                      ),
                    );
                  }
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

                leftScore = double.parse(leftScore.toStringAsFixed(4));
                rightScore = double.parse(rightScore.toStringAsFixed(4));
                for (var i = 0; i < 4; i++) {
                  leftSimList[i] = double.parse(leftSimList[i].toStringAsFixed(4));
                  rightSimList[i] = double.parse(rightSimList[i].toStringAsFixed(4));
                }

                if (context.mounted) {
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
                      ),
                    ),
                  );
                }
              },
              child: const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}