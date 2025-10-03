import 'package:flutter/material.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/widgets/admin/Hospital/diet/add_diet_Admin_card.dart';

class AddDietAdminView extends StatelessWidget {
  static const String routerName = 'addDietAdmin';
  static const String routerPath = '/add_diet_admin';

  const AddDietAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppStyle.ligthGrey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppStyle.primary),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Registrar Dieta",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              letterSpacing: 0.5,
            ),
          ),
        ),
        body: const SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: AddDietAdminCard(),
        ),
      ),
    );
  }
}
