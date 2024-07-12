import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;

import 'package:fingerprint/models/user.dart';

checkUsername(String url, String username) async {
  final headers = {'Content-Type': 'application/json'};
  Map<String, dynamic> request = {'username': username};
  final response = await http.post(Uri.parse(url), headers: headers, body: json.encode(request));
  return json.decode(response.body);
}

enrollUser(String url, User user) async {
  final headers = {'Content-Type': 'application/json'};
  Map<String, dynamic> request = {
    'username': user.username,
    'password': user.password,
    'leftFingerprintPath': user.leftFingerprintPath,
    'rightFingerprintPath': user.rightFingerprintPath
  };
  final response = await http.post(Uri.parse(url), headers: headers, body: json.encode(request));
  return json.decode(response.body);
}

checkCredentials(String url, User user) async {
  final headers = {'Content-Type': 'application/json'};
  Map<String, dynamic> request = {'username': user.username, 'password': user.password};
  final response = await http.post(Uri.parse(url), headers: headers, body: json.encode(request));
  return json.decode(response.body);
}

verifyFingerprints(String url, User user) async {
  final headers = {'Content-Type': 'application/json'};
  Map<String, dynamic> request = {
    'leftFingerprintPath': user.leftFingerprintPath,
    'rightFingerprintPath': user.rightFingerprintPath
  };
  final response = await http.post(Uri.parse(url), headers: headers, body: json.encode(request));
  return json.decode(response.body);
}

uploadImageToServer(File imageFile) async {
  print("attempting to connect to server......");
  var stream = new http.ByteStream(DelegatingStream(imageFile.openRead()));
  var length = await imageFile.length();
  print(length);

  var uri = Uri.parse('http://10.0.2.2:5000/predict');
  print("connection established.");
  
  var request = new http.MultipartRequest("POST", uri);
  var multipartFile = new http.MultipartFile('file', stream, length, filename: basename(imageFile.path));
      //contentType: new MediaType('image', 'png'));

  request.files.add(multipartFile);
  var response = await request.send();
  print(response.statusCode);
}