import 'package:flutter/material.dart';
import 'package:tusalud/api/response/app/ts_medication_response.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/widgets/admin/Hospital/medicine/edit_medicine_card.dart';

class EditMedicineAdminView extends StatelessWidget {
  final TsMedicineResponse medicine;

  const EditMedicineAdminView({super.key, required this.medicine});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.ligthGrey,
      appBar: AppBar(
        backgroundColor: AppStyle.ligthGrey,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppStyle.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Editar Medicamento",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: EditMedicineAdminCard(medicine: medicine),
        ),
      ),
    );
  }
}
