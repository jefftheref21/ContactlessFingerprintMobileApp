import 'package:flutter/material.dart';
import 'package:fingerprint/constants.dart';

class IdentificationResultsPage extends StatefulWidget {
  const IdentificationResultsPage({
    super.key,
    required this.matchFound,
    required this.username,
    required this.score
  });

  final bool matchFound;
  final String username;
  final double score;

  @override
  State<IdentificationResultsPage> createState() => _IdentificationResultsPageState();
}

class _IdentificationResultsPageState extends State<IdentificationResultsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fingerprint Identification'),
        automaticallyImplyLeading: false,
      ),
      body: widget.matchFound ?
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Identification Complete!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Identified as ${widget.username}',
              style: const TextStyle(
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              'Score: ${widget.score}',
              style: const TextStyle(
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ) :
      Center(
        child: Column(
          children: <Widget>[
            const Text("No match found", style: TextStyle(fontSize: 30)),
            const SizedBox(height: 20),
            const Text("Make sure to enroll your fingerprints first.", style: TextStyle(fontSize: 18)),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}