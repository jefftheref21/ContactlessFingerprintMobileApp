import 'package:flutter/material.dart';
import 'package:fingerprint/pages/enrollment_scan_page.dart';
import 'package:fingerprint/constants.dart';
import 'package:fingerprint/network_call.dart';
import 'package:fingerprint/models/user.dart';

class EnrollmentPage extends StatefulWidget {
  const EnrollmentPage({
    super.key, 
    required this.uri,
    required this.title,
  });

  final String uri;
  final String title;

  @override
  State<EnrollmentPage> createState() => _EnrollmentPageState();
}


class _EnrollmentPageState extends State<EnrollmentPage>{
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  late bool passwordVisible;
  late User user;

  @override
  void initState() {
    super.initState();
    passwordVisible = false;
    user = User(username: '', password: '', leftFingerprintPath: '', rightFingerprintPath: '');
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
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
                  Icons.assignment_add, 
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
                    color: MyColors.harrimanBlue
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 30.0, left: 30.0, right: 30.0),
              child: TextFormField(
                controller: usernameController,
                validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Enter your username',
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(
                  color: MyColors.harrimanBlue,
                )
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
                    color: MyColors.harrimanBlue
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, left: 30.0, right: 30.0),
              child: Center(
                child: TextFormField(
                  obscureText: !passwordVisible,
                  controller: passwordController,
                  validator: (value) {
                    // Make sure password is valid
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    else if (value.length < 4) {
                      return 'Password must be at least 4 characters long';
                    }
                    return null;
                  },
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
                  style: const TextStyle(
                    color: MyColors.harrimanBlue
                  )
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  }

                  user.username = usernameController.text;
                  user.password = passwordController.text;
                  final check = await checkUsername(widget.uri, user.username);
      
                  if (!context.mounted) return;
                  if (check != 200) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Username is already taken.'),
                      ),
                    );
                    return;
                  }

                  usernameController.clear();
                  passwordController.clear();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return EnrollmentScanPage(
                          uri: '${widget.uri}/scan',
                          user: user,
                        );
                      },
                    ),
                  );
              },
                child: const Text('Next'),
              ),
            ),
            const SizedBox(height: 120)
          ],
        ),
      ),
    );
  }
}