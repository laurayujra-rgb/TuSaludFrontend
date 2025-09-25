import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tusalud/views/views.dart';

class DrawerProvider extends ChangeNotifier {
  goToHomeAdmin(BuildContext context){
    context.pushNamed(HomeAdminView.routerName);
  }
}