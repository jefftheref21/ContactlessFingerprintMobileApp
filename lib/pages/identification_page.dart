import 'dart:io';
import 'package:flutter/material.dart';

import 'package:fingerprint/constants.dart';

class IdentificationPage extends StatefulWidget {
  const IdentificationPage({
    super.key,
  });

  @override
  State<IdentificationPage> createState() => _IdentifierPageState();
}

enum Mode { distal, setBased, fourFingers }

class _IdentifierPageState extends State<IdentificationPage> {
  Mode defaultMode = Mode.distal;

  @override
  Widget build(BuildContext context) {
    return Center(
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
          SegmentedButton<Mode>(
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

          /*
          OverflowBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton( child: const Text('Single Finger'),

                onPressed: () {},
              ),
              ElevatedButton( child: const Text('Set-based'), onPressed: () {}),
              ElevatedButton( child: const Text('Four Fingers'), onPressed: () {}),
            ],
          ),*/
        ],
      ),
    );
  }
}