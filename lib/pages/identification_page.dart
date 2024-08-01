import 'dart:io';
import 'dart:convert';
import 'package:fingerprint/pages/identification_results_page.dart';
import 'package:flutter/material.dart';
import 'package:fingerprint/pages/camera_page.dart';
import 'package:fingerprint/pages/loading_page.dart';

import 'package:fingerprint/network_call.dart';

import 'package:fingerprint/constants.dart';

class IdentificationPage extends StatefulWidget {
  const IdentificationPage({
    super.key,
    required this.uri,
    required this.title,
  });

  final String uri;
  final String title;

  @override
  State<IdentificationPage> createState() => _IdentifierPageState();
}

enum Mode { distal, setBased, fourFingers }

class _IdentifierPageState extends State<IdentificationPage> {
  late Mode defaultMode;
  late String fingerprintPath;
  late bool scanComplete;
  late bool leftSide;

  @override
  void initState() {
    super.initState();
    defaultMode = Mode.distal;
    scanComplete = false;
    leftSide = true;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 30.0, bottom: 15.0),
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: MyColors.bairdPoint)),
              child: const Icon(
                Icons.perm_identity,
                size: 80,
                color: MyColors.bairdPoint,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0, bottom: 15.0, left: 15.0, right: 15.0),
            child: SegmentedButton<Mode>(
              segments: const <ButtonSegment<Mode>>[
                ButtonSegment<Mode>(
                    value: Mode.distal,
                    label: Text('Distal'),
                    icon: Icon(Icons.sensors)),
                ButtonSegment<Mode>(
                    value: Mode.setBased,
                    label: Text('Set-based'),
                    icon: Icon(Icons.photo_library)),
                ButtonSegment<Mode>(
                    value: Mode.fourFingers,
                    label: Text('Four Fingers'),
                    icon: Icon(Icons.back_hand)),
              ],
              selected: <Mode>{defaultMode},
              onSelectionChanged: (Set<Mode> newSelection) {
                setState(() {
                  // By default there is only a single segment that can be
                  // selected at one time, so its value is always the first
                  // item in the selected set.
                  defaultMode = newSelection.first;
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Radio<bool>(
                value: true,
                groupValue: leftSide,
                fillColor: WidgetStateProperty.all<Color>(MyColors.harrimanBlue),
                onChanged: (bool? value) {
                  setState(() {
                    leftSide = value!;
                  });
                },
              ),
              const Text('Left', style: TextStyle(fontSize: 16, color: MyColors.harrimanBlue)),
              const SizedBox(width: 20),
              Radio<bool>(
                value: false,
                groupValue: leftSide,
                fillColor: WidgetStateProperty.all<Color>(MyColors.harrimanBlue),
                onChanged: (bool? value) {
                  setState(() {
                    leftSide = value!;
                  });
                },
              ),
              const Text('Right', style: TextStyle(fontSize: 16, color: MyColors.harrimanBlue)),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 30.0, right: 30.0),
            child: Text("Make sure you have already enrolled your fingerprints.",
              style: TextStyle(fontSize: 18, color: MyColors.bairdPoint),
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              fingerprintPath = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return CameraPage(
                      title: "Identification Scan",
                      leftSide: leftSide,
                      );
                  },
                ),
              );
              setState(() {
                scanComplete = true;
              });
            },
            child: const Text('Scan'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (scanComplete == false) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please scan your fingerprint first."),
                  ),
                );
                return;
              }

              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoadingPage()));

              final response = await identifyFingerprint(widget.uri, fingerprintPath, leftSide ? "left" : "right");

              if (!context.mounted) return;
              Navigator.pop(context);

              if (response.statusCode != 200) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Identification failed.'),
                  ),
                );
                return;
              }

              final responseBody = await response.stream.bytesToString();
              final result = json.decode(responseBody);

              var score = result['score'];
              var username = result['username'];

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => IdentificationResultsPage(username: username, score: score),
                ),
              );
            },
            child: const Text("Identify")
          )
        ],
      ),
    );
  }
}