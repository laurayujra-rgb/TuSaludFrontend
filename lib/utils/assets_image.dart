import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


abstract class AssetsImages{
    static Widget getImage({
    double? height,
    String? ext = 'png',
    double? width,
    required String path
  }){
    if(ext == 'svg'){
      return SvgPicture.asset(
        path,
        height: height,
        width: width,
      );
    }
    return Image.asset(
      path,
      height: height,
      width: width,
    );
  }

  static Widget admin({double? height, double? width}){
    return getImage(
      ext: 'jpg',
      path: 'assets/admin.jpg',
      height: height,
      width: width
    );
  }
  
  static Widget customer({double? height, double? width}){
    return getImage(
      ext: 'jpg',
      path: 'assets/customer.jpg',
      height: height,
      width: width
    );
  }

  static Widget employee({double? height, double? width}){
    return getImage(
      ext: 'jpg',
      path: 'assets/employee.jpg',
      height: height,
      width: width
    );
  }

  static Widget logo({double? height, double? width}){
    return getImage(
      ext: 'png',
      path: 'assets/logo.png',
      height: height,
      width: width
    );
  }

  static Widget logoAvatar({double? height, double? width}){
    return getImage(
      ext: 'png',
      path: 'assets/logoAvatar.png',
      height: height,
      width: width
    );
  }

  static Widget map({double? height, double? width}){
    return getImage(
      ext: 'png',
      path: 'assets/map.png',
      height: height,
      width: width
    );
  }

  static Widget singleFingerLeftSlip({double? height, double? width}){
    return getImage(
      ext: 'svg',
      path: 'assets/single_finger_left_slip.svg',
      height: height,
      width: width
    );
  }

  static Widget singleFingerRightSlide({double? height, double? width}){
    return getImage(
      ext: 'svg',
      path: 'assets/single_finger_right_slide.svg',
      height: height,
      width: width
    );
  }
}