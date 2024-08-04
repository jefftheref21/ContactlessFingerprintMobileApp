import 'package:flutter/material.dart';
import 'package:fingerprint/constants.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({
    super.key,
  });

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(MyColors.harrimanBlue),
          ),
          SizedBox(height: 20),
          Text(
            'Please wait...',
            style: TextStyle(
              fontSize: 30,
              color: MyColors.harrimanBlue,
            ),
          ),
        ],
      ),
    );
  }
}