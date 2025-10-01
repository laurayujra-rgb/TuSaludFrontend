import 'package:flutter/material.dart';
import 'package:tusalud/style/app_style.dart';

class AddReportsNurseCard extends StatelessWidget {
  final TextEditingController reportDetailsController;

  const AddReportsNurseCard({
    super.key,
    required this.reportDetailsController,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Nuevo Reporte de Enfermería",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppStyle.textDark,
              ),
            ),
            const SizedBox(height: 16),

            // Campo del formulario
            TextFormField(
              controller: reportDetailsController,
              minLines: 5,
              maxLines: 10,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Por favor ingresa los detalles del reporte";
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: "Detalles del reporte",
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: AppStyle.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
