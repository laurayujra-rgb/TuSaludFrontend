import 'package:flutter/material.dart';
import 'package:tusalud/api/response/app/ts_medication_response.dart';
import 'package:tusalud/style/app_style.dart';

class MedicineNurseCard extends StatelessWidget {
  final TsMedicineResponse medicine;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const MedicineNurseCard({
    super.key,
    required this.medicine,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nombre del medicamento
            Text(
              medicine.medicineName ?? "Sin nombre",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppStyle.primary,
              ),
            ),
            const SizedBox(height: 8),

            // Detalles principales
            Text("📅 Hasta: ${medicine.medicineDateToEnd ?? '-'}",
                style: const TextStyle(fontSize: 14)),
            Text("🌅 Mañana: ${medicine.medicineMoorning ?? '-'}",
                style: const TextStyle(fontSize: 14)),
            Text("🌞 Tarde: ${medicine.medicineAfternoon ?? '-'}",
                style: const TextStyle(fontSize: 14)),
            Text("🌙 Noche: ${medicine.medicineEvening ?? '-'}",
                style: const TextStyle(fontSize: 14)),
            Text("💊 Vía: ${medicine.via.viaName ?? '-'}",
                style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),

            const SizedBox(height: 12),

            // Botones de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onEdit != null)
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: onEdit,
                  ),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: onDelete,
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
