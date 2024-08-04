import 'dart:io';

class Results {
  double leftScore;
  double rightScore;
  final String leftPred;
  final String rightPred;
  List<dynamic> leftSimList;
  List<dynamic> rightSimList;
  File? leftEnrBbox;
  File? rightEnrBbox;
  File? leftInpBbox;
  File? rightInpBbox;
  List<File> leftEnrEnh;
  List<File> rightEnrEnh;
  List<File> leftInpEnh;
  List<File> rightInpEnh;

  Results({
    required this.leftScore,
    required this.rightScore,
    required this.leftPred,
    required this.rightPred,
    required this.leftSimList,
    required this.rightSimList,
    this.leftEnrBbox,
    this.rightEnrBbox,
    this.leftInpBbox,
    this.rightInpBbox,
    required this.leftEnrEnh,
    required this.rightEnrEnh,
    required this.leftInpEnh,
    required this.rightInpEnh,
  });

  void roundScores() {
    leftScore = double.parse(leftScore.toStringAsFixed(4));
    rightScore = double.parse(rightScore.toStringAsFixed(4));
    for (var i = 0; i < 4; i++) {
      leftSimList[i] = double.parse(leftSimList[i].toStringAsFixed(4));
      rightSimList[i] = double.parse(rightSimList[i].toStringAsFixed(4));
    }
  }

  void orderFingerprints() {
    // Sort Fingerprints based on numbering of filenames
    leftEnrEnh.sort((a, b) => a.path.compareTo(b.path));
    rightEnrEnh.sort((a, b) => a.path.compareTo(b.path));
    leftInpEnh.sort((a, b) => a.path.compareTo(b.path));
    rightInpEnh.sort((a, b) => a.path.compareTo(b.path));
  }
}