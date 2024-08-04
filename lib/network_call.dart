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
  // print(json.decode(response.body)['message']);
  return response.statusCode;
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
  var leftImage = http.MultipartFile('file1', leftStream, leftLength, filename: basename(leftFile.path));
  var rightImage = http.MultipartFile('file2', rightStream, rightLength, filename: basename(rightFile.path));

  request.fields['username'] = user.username;
  request.fields['password'] = user.password;
  request.files.add(leftImage);
  request.files.add(rightImage);

  final response = await request.send();
  print(response.statusCode);
  if (response.statusCode == 200) {
    var body = await response.stream.bytesToString();
    var jsonResponse = json.decode(body);
    print(jsonResponse['message']);
  }
  return response.statusCode;
}

checkCredentials(String uri, User user) async {
  final headers = {'Content-Type': 'application/json'};
  Map<String, dynamic> request = {'username': user.username, 'password': user.password};
  final response = await http.post(Uri.parse(uri), headers: headers, body: json.encode(request));
  print(response.statusCode);
  print(json.decode(response.body)['message']);
  return response;
}

verifyFingerprints(String uri, User user, String enrolled1, String enrolled2) async {
  print("attempting to connect to server......");
  File leftFile = File(user.leftFingerprintPath);
  File rightFile = File(user.rightFingerprintPath);

  var leftStream = http.ByteStream(DelegatingStream(leftFile.openRead()));
  var rightStream = http.ByteStream(DelegatingStream(rightFile.openRead()));
  var leftLength = await leftFile.length();
  var rightLength = await rightFile.length();
  
  var request = http.MultipartRequest("POST", Uri.parse(uri));
  var leftImage = http.MultipartFile('file1', leftStream, leftLength, filename: basename(leftFile.path));
  var rightImage = http.MultipartFile('file2', rightStream, rightLength, filename: basename(rightFile.path));

  request.fields['enrolled1'] = enrolled1;
  request.fields['enrolled2'] = enrolled2;
  request.files.add(leftImage);
  request.files.add(rightImage);

  final response = await request.send();
  print(response.statusCode);
  return response;
}

identifyFingerprint(String uri, String fingerprintPath, String type) async {
  File file = File(fingerprintPath);
  var stream = http.ByteStream(DelegatingStream(file.openRead()));
  var length = await file.length();
  var request = http.MultipartRequest("POST", Uri.parse(uri));
  var image = http.MultipartFile('file', stream, length, filename: basename(file.path));

  request.files.add(image);
  request.fields['type'] = type;

  final response = await request.send();
  print(response.statusCode);
  return response;
}