import 'package:flutter/material.dart';

import 'package:fingerprint/models/user.dart';
import 'package:fingerprint/constants.dart';

class VerificationResultsPage extends StatefulWidget {
  VerificationResultsPage({
    Key? key,
    required this.user,
    this.score = 0.0,
    this.pred = false,
    this.simList = const <double>[0.5, 0.3, 0.2, 0.4],
  }) : super(key: key);

  final User user;
  final double score;
  final bool pred;
  final List<double> simList;

  @override
  State<VerificationResultsPage> createState() => _VerificationResultsPageState();
}

class _VerificationResultsPageState extends State<VerificationResultsPage> with SingleTickerProviderStateMixin{
  late TabController _tabController;

  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              // Handle search button press
            },
          ),
          // Add more IconButton widgets as needed
        ],
        title: const Text('Verification Results'),
        automaticallyImplyLeading: false,
        actionsIconTheme: const IconThemeData(
          color: MyColors.bairdPoint,
        ),
        bottom: TabBar(
          labelColor: MyColors.bairdPoint,
          indicatorColor: MyColors.bairdPoint,
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              icon: Icon(Icons.score),
              text: 'Scores',
            ),
            Tab(
              icon: Icon(Icons.sensors),
              text: 'Detection'
            ),
            Tab(
              icon: Icon(Icons.zoom_in),
              text: 'Enhancement'
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              //const SizedBox(height: 20,),
              Text("Results for ${widget.user.username}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("Your fingerprints have a matching score of ${widget.score}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("Prediction: ${widget.pred}",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("Matching Distals:"),
              for (double i in widget.simList) Text("Fingerprint $i"),

            ],
          ),
          Center(
            child: Text("test"),
          ),
          Center(
            child: Text("test"),
          ),
        ],
      )
    );
  }
}