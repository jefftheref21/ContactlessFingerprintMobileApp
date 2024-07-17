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

enrollUser(String uri, User user) async {
  print("attempting to connect to server......");
  File leftFile = File(user.leftFingerprintPath);
  File rightFile = File(user.rightFingerprintPath);
  
  var leftStream = http.ByteStream(DelegatingStream(leftFile.openRead()));
  var rightStream = http.ByteStream(DelegatingStream(rightFile.openRead()));
  var leftLength = await leftFile.length();
  var rightLength = await rightFile.length();
  
  var request = http.MultipartRequest("POST", Uri.parse(uri));
  var leftImage = http.MultipartFile('image', leftStream, leftLength, filename: basename(leftFile.path));
  var rightImage = http.MultipartFile('image', rightStream, rightLength, filename: basename(rightFile.path));

  request.fields['username'] = user.username;
  request.fields['password'] = user.password;
  request.files.add(leftImage);
  request.files.add(rightImage);

  final response = await request.send();
  return response.statusCode;
}

checkCredentials(String url, User user) async {
  final headers = {'Content-Type': 'application/json'};
  Map<String, dynamic> request = {'username': user.username, 'password': user.password};
  final response = await http.post(Uri.parse(url), headers: headers, body: json.encode(request));
  return json.decode(response.body);
}

verifyFingerprints(String uri, User user) async {
  final headers = {'Content-Type': 'application/json'};
  Map<String, dynamic> request = {
    'leftFingerprintPath': user.leftFingerprintPath,
    'rightFingerprintPath': user.rightFingerprintPath
  };
  final response = await http.post(Uri.parse(uri), headers: headers, body: json.encode(request));
  return json.decode(response.body);
}

uploadImageToServer(String uri, File imageFile) async {
  print("attempting to connect to server......");
  var stream = http.ByteStream(DelegatingStream(imageFile.openRead()));
  var length = await imageFile.length();
  print(length);
  
  var request = http.MultipartRequest("POST", Uri.parse(uri));
  var multipartFile = http.MultipartFile('image', stream, length, filename: basename(imageFile.path));

  request.files.add(multipartFile);
  var response = await request.send();
  print(response.statusCode);
}