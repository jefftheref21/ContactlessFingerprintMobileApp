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
    this.leftEnrEnh = const [],
    this.rightEnrEnh = const [],
    this.leftInpEnh = const [],
    this.rightInpEnh = const [],
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