
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../views/views.dart';

class SelectModeProvider extends ChangeNotifier{
  void goToAdmin(BuildContext context){
    context.goNamed(HomeAdminView.routerName);
  }

  void goToCustomer(BuildContext context){
    context.goNamed(HomeNurseView.routerName);
  }

  void goToEmployee(BuildContext context){
    context.goNamed(HomeSupervisorView.routerName);
  }
}