import 'package:flutter/material.dart';

import 'package:fingerprint/models/user.dart';
import 'package:fingerprint/constants.dart';

class VerificationResultsPage extends StatefulWidget {
  const VerificationResultsPage({
    super.key,
    required this.user,
    required this.leftScore,
    required this.rightScore,
    required this.leftPred,
    required this.rightPred,
    required this.leftSimList,
    required this.rightSimList,
  });

  final User user;
  final double leftScore;
  final double rightScore;
  final String leftPred;
  final String rightPred;
  final List<dynamic> leftSimList;
  final List<dynamic> rightSimList;

  @override
  State<VerificationResultsPage> createState() => _VerificationResultsPageState();
}

class _VerificationResultsPageState extends State<VerificationResultsPage> with SingleTickerProviderStateMixin{
  late TabController _tabController;
  
  @override
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
            icon: const Icon(Icons.exit_to_app),
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
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  color: MyColors.lakeLaselle,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      const Text(
                        'Left',
                        style: TextStyle(fontWeight: FontWeight.bold, color: MyColors.niagaraWhirlpool, fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      Text("${widget.leftScore}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: MyColors.niagaraWhirlpool,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(widget.leftPred,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: MyColors.niagaraWhirlpool,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(""), // Placeholder for spacing
                      for (double i in widget.leftSimList) Text("$i", style: const TextStyle(fontWeight: FontWeight.bold, color: MyColors.niagaraWhirlpool)),
                    ]
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  color: MyColors.niagaraWhirlpool,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text("Results for ${widget.user.username}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: MyColors.bairdPoint,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text("Final Matching Score",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: MyColors.bairdPoint,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text("Prediction",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: MyColors.bairdPoint,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text("Distal Matching scores",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: MyColors.bairdPoint,
                        ),
                      ),
                      for (int i = 1; i < 5; i++) Text("Fingerprint $i", style: const TextStyle(fontWeight: FontWeight.bold, color: MyColors.bairdPoint)),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: MyColors.lakeLaselle,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      const Text(
                        'Right',
                        style: TextStyle(fontWeight: FontWeight.bold, color: MyColors.niagaraWhirlpool, fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      Text("${widget.rightScore}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: MyColors.niagaraWhirlpool,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(widget.rightPred,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: MyColors.niagaraWhirlpool,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(""), // Placeholder for spacing
                      for (double i in widget.rightSimList) Text("$i", style: const TextStyle(fontWeight: FontWeight.bold, color: MyColors.niagaraWhirlpool)),
                    ]
                  ),
                ),
              ),
            ]
          ),
          Row(
            children: <Widget>[

            ],
          ),
          Center(
            child: Text("test"),
          ),
        ],
      )
    );
  }
}