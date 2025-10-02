import 'package:flutter/material.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/widgets/admin/beds/add_bed_card.dart';

class AddBedAdminView extends StatelessWidget {
  static const String routerName = 'addBedAdmin';
  static const String routerPath = '/add_bed_admin';

  const AddBedAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Agregar Cama",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: AddBedAdminCard(
          onSuccess: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
