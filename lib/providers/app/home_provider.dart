import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tusalud/style/app_style.dart';


class HomeProvider extends ChangeNotifier{
  int _currentIndex = 0;
  final List<Color> _gradientColors = [
    AppStyle.primaryLigth,
    AppStyle.primary,
  ];

  int get currentIndex => _currentIndex;
  List<Color> get gradientColors => _gradientColors;

  void changeNavBar(BuildContext context, int index, String route){
    _currentIndex = index;
    context.goNamed(route);
    notifyListeners();
  }
}