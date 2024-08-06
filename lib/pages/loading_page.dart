import 'package:flutter/material.dart';
import 'package:fingerprint/constants.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({
    super.key,
  });

  @override
  State<LoadingPage> createState() => LoadingPageState();
}

class LoadingPageState extends State<LoadingPage> {
  late String? _message;

  @override
  void initState() {
    super.initState();
    _message = "Please wait...";
  }

  void updateMessage(String newMessage) {
    setState(() {
      _message = newMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(MyColors.harrimanBlue),
            ),
            const SizedBox(height: 20),
            Text(
              _message!,
              style: const TextStyle(
                fontSize: 30,
                color: MyColors.harrimanBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}