import 'package:fingerprint/network_call.dart';
import 'package:fingerprint/pages/verification_results_page.dart';
import 'package:flutter/material.dart';
import 'package:fingerprint/constants.dart';
import 'package:fingerprint/pages/camera_page.dart';
import 'package:fingerprint/models/user.dart';
import 'package:fingerprint/models/full_results.dart';
import 'package:fingerprint/pages/loading_page.dart';

import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart'; // For directory paths
import 'package:archive/archive.dart'; 


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

                LoadingPage lp = LoadingPage();

                Navigator.push(context, MaterialPageRoute(builder: (context) => lp));

                print(widget.user.leftFingerprintPath);

                final response = await verifyFingerprints(widget.uri, widget.user, enrolled1, enrolled2);

                if (!context.mounted) return;
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

                lp.message = 'Compiling Images...';

                Results fullResults = Results(
                  leftScore: result['left_score'],
                  rightScore: result['right_score'],
                  leftPred: result['left_pred'],
                  rightPred: result['right_pred'],
                  leftSimList: result['left_sim_list'],
                  rightSimList: result['right_sim_list'],
                );

                final Uint8List zipBytes = base64Decode(result['zip_file']);

                final Archive archive = ZipDecoder().decodeBytes(zipBytes);

                final Directory tempDir = await getTemporaryDirectory();
                final String tempPath = tempDir.path;

                for (final ArchiveFile file in archive) {
                  if (file.isFile) {
                    final String filename = file.name;
                    final String filePath = '$tempPath/$filename';
                    final File outputFile = File(filePath);

                    await outputFile.writeAsBytes(file.content as List<int>);

                    if (filename == 'left_enr_bbox.jpg') {
                      fullResults.leftEnrBbox = outputFile;
                    }
                    else if (filename == 'right_enr_bbox.jpg') {
                      fullResults.rightEnrBbox = outputFile;
                    }
                    else if (filename == 'left_inp_bbox.jpg') {
                      fullResults.leftInpBbox = outputFile;
                    }
                    else if (filename == 'right_inp_bbox.jpg') {
                      fullResults.rightInpBbox = outputFile;
                    }
                    else if (filename.startsWith('left_enr_enh')) {
                      fullResults.leftEnrEnh.add(outputFile);
                    }
                    else if (filename.startsWith('right_enr_enh')) {
                      fullResults.rightEnrEnh.add(outputFile);
                    }
                    else if (filename.startsWith('left_inp_enh')) {
                      fullResults.leftInpEnh.add(outputFile);
                    }
                    else if (filename.startsWith('right_inp_enh')) {
                      fullResults.rightInpEnh.add(outputFile);
                    }
                    print("File saved to $filePath");
                  }
                }
                
                if (!context.mounted) return;
                Navigator.pop(context);
                
                fullResults.roundScores();
                fullResults.orderFingerprints();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VerificationResultsPage(
                      user: widget.user,
                      results: fullResults
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