import 'package:flutter/material.dart';
import 'package:tusalud/api/response/app/ts_diet_response.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/widgets/admin/Hospital/diet/edit_diet_admin_card.dart';

class EditDietAdminView extends StatelessWidget {
  final TsDietResponse diet;

  const EditDietAdminView({super.key, required this.diet});

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
          "Editar Dieta",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: EditDietAdminCard(diet: diet),
      ),
    );
  }
}
