import 'package:flutter/material.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/api/response/app/ts_bed_response.dart';
import 'package:tusalud/widgets/admin/beds/edit_bed_card.dart';

class EditBedAdminView extends StatelessWidget {
  final TsBedsResponse bed;

  const EditBedAdminView({super.key, required this.bed});

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
          "Editar Cama",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: EditBedAdminCard(bed: bed),
      ),
    );
  }
}
