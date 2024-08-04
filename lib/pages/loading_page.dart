import 'package:flutter/material.dart';
import 'package:fingerprint/constants.dart';

class LoadingPage extends StatefulWidget {
  LoadingPage({
    super.key,
    this.message = "Please wait...",
  });

  String message;

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(MyColors.harrimanBlue),
          ),
          const SizedBox(height: 20),
          Text(
            widget.message,
            style: const TextStyle(
              fontSize: 30,
              color: MyColors.harrimanBlue,
            ),
          ),
        ],
      ),
    );
  }
}