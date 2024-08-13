import 'package:flutter/material.dart';

// University of Buffalo colors
class MyColors {
  static const Color ubBlue = Color(0xff005bbb);
  static const Color hayesHallWhite =Color(0xffffffff);
  static const Color bronzeBuffalo = Color(0xffad841f);
  static const Color lakeLaselle = Color.fromRGBO(0, 166, 156, 1);
  static const Color victorEBlue = Color(0xff2f9fd0);
  static const Color niagaraWhirlpool = Color(0xff006570);
  static const Color harrimanBlue = Color(0xff002f56);
  static const Color bairdPoint = Color(0xffe4e4e4);
  static const Color townsendGray = Color(0xff666666);
}

Image overlay = Image.asset("assets/fingerprint_overlay.png");

// Icons used in the app
class MyIcons {
  static const ImageIcon verificationIcon = ImageIcon(AssetImage("assets/verification_icon.png"), color: MyColors.harrimanBlue,  size: 140);
  static const ImageIcon enrollmentIcon = ImageIcon(AssetImage("assets/enrollment_icon.png"), color: MyColors.harrimanBlue,  size: 140);
  static const ImageIcon cameraIcon = ImageIcon(AssetImage("assets/camera_icon.png"), color: MyColors.harrimanBlue,  size: 140);
  
  static const List flashIcons = [Icons.flash_auto, Icons.flash_on, Icons.flash_off];
}