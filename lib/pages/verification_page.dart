
import 'package:flutter/material.dart';
import 'package:fingerprint/constants.dart';
import 'package:fingerprint/pages/verification_scan_page.dart';
import 'package:fingerprint/models/user.dart';

import 'package:fingerprint/network_call.dart';
import 'dart:convert';

class VerificationPage extends StatefulWidget {
  const VerificationPage({
    super.key,
    required this.uri,
    required this.title,
  });

  final String uri;
  final String title;

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late bool passwordVisible;

  @override
  void initState() {
    super.initState();
    passwordVisible = false;
    usernameController = TextEditingController();
    passwordController = TextEditingController();
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
                Icons.fingerprint, 
                size: 80, 
                color: MyColors.bairdPoint, 
              ), 
            ), 
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Text(
                'Username',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 30.0, left: 30.0, right: 30.0),
            child: TextFormField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Enter your username',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Text(
                'Password',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15.0, left: 30.0, right: 30.0),
            child: TextFormField(
              obscureText: !passwordVisible,
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Enter your password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(passwordVisible ? Icons.visibility: Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                        passwordVisible = !passwordVisible;
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 30.0, right: 30.0),
            child: ElevatedButton(
              onPressed: () async {
                User user = User(username: usernameController.text, password: passwordController.text);
                final response = await checkCredentials(widget.uri, user);
                if (response.statusCode == 200) {
                  var responseBody = await json.decode(response.body);
                  user.leftFingerprintPath = responseBody['leftFingerprintPath'];
                  user.rightFingerprintPath = responseBody['rightFingerprintPath'];
                }
                else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(response['message']),
                      ),
                    );
                  }
                  return;
                }
                usernameController.clear();
                passwordController.clear();

                if (context.mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return VerificationScanPage(
                          uri: '${widget.uri}/scan',
                          user: user,
                        );
                      },
                    ),
                  );
                }
              },
              child: const Text('Next'),
            ),
          ),
        ],
      ),
    );
  }
}