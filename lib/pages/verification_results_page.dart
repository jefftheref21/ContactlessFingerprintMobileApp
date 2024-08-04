import 'package:flutter/material.dart';

import 'package:fingerprint/models/user.dart';
import 'package:fingerprint/models/full_results.dart';
import 'package:fingerprint/constants.dart';
import 'dart:typed_data';

class VerificationResultsPage extends StatefulWidget {
  const VerificationResultsPage({
    super.key,
    required this.user,
    required this.results,
  });

  final User user;
  final Results results;

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
                      Text("${widget.results.leftScore}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: MyColors.niagaraWhirlpool,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(widget.results.leftPred,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: MyColors.niagaraWhirlpool,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(""), // Placeholder for spacing
                      for (double i in widget.results.leftSimList) Text("$i", style: const TextStyle(fontWeight: FontWeight.bold, color: MyColors.niagaraWhirlpool)),
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
                      Text("${widget.results.rightScore}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: MyColors.niagaraWhirlpool,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(widget.results.rightPred,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: MyColors.niagaraWhirlpool,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(""), // Placeholder for spacing
                      for (double i in widget.results.rightSimList) Text("$i", style: const TextStyle(fontWeight: FontWeight.bold, color: MyColors.niagaraWhirlpool)),
                    ]
                  ),
                ),
              ),
            ]
          ),
          SingleChildScrollView(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: MyColors.lakeLaselle,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        const Text(
                          'Enrolled Fingerprint',
                          style: TextStyle(fontWeight: FontWeight.bold, color: MyColors.niagaraWhirlpool, fontSize: 16),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          child: Image.file(widget.results.leftEnrBbox!, width: 240, height: 240)
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          child: Image.file(widget.results.rightEnrBbox!, width: 240, height: 240)
                        ),
                      ]
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: MyColors.niagaraWhirlpool,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        const Text(
                          'Inputted Fingerprint',
                          style: TextStyle(fontWeight: FontWeight.bold, color: MyColors.bairdPoint, fontSize: 16),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          child: Image.file(widget.results.leftInpBbox!, width: 240, height: 240)
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                          child: Image.file(widget.results.rightInpBbox!, width: 240, height: 240)
                        ),
                      ]
                    ),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                const Text("Left Hand", style: TextStyle(fontWeight: FontWeight.bold, color: MyColors.bairdPoint, fontSize: 16)),
                Expanded(
                  child: Container(
                    color: MyColors.lakeLaselle,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        const Text('Enrolled', style: TextStyle(fontWeight: FontWeight.bold, color: MyColors.niagaraWhirlpool, fontSize: 16)),
                        for (var enh in widget.results.leftEnrEnh) 
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Image.file(enh, width: 90, height: 120),
                          ),
                      ]
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: MyColors.niagaraWhirlpool,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        const Text('Input', style: TextStyle(fontWeight: FontWeight.bold, color: MyColors.niagaraWhirlpool, fontSize: 16)),
                        for (var enh in widget.results.leftInpEnh) 
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Image.file(enh, width: 90, height: 120),
                          ),
                      ]
                    ),
                  ),
                ),
                const Text("Right Hand", style: TextStyle(fontWeight: FontWeight.bold, color: MyColors.bairdPoint, fontSize: 16)),
                Expanded(
                  child: Container(
                    color: MyColors.lakeLaselle,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        const Text('Enrolled', style: TextStyle(fontWeight: FontWeight.bold, color: MyColors.niagaraWhirlpool, fontSize: 16)),
                        for (var enh in widget.results.rightEnrEnh)
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Image.file(enh, width: 90, height: 120),
                          ),
                      ]
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: MyColors.niagaraWhirlpool,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        const Text('Input', style: TextStyle(fontWeight: FontWeight.bold, color: MyColors.niagaraWhirlpool, fontSize: 16)),
                        for (var enh in widget.results.rightInpEnh)
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Image.file(enh, width: 90, height: 120)
                          ),
                      ]
                    ),
                  ),
                )
              ],)
          )
        ],
      )
    );
  }
}