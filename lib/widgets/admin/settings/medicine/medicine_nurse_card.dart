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
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: AppStyle.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Header con icono + nombre
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppStyle.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.medication, color: AppStyle.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    medicine.medicineName ?? "Sin nombre",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 🔹 Detalles
            Text("🏭 Laboratorio: ${medicine.medicineLaboratory ?? '-'}",
                style: const TextStyle(fontSize: 14, color: Colors.black54)),
            const SizedBox(height: 4),
            Text("💊 Vía: ${medicine.via.viaName ?? '-'}",
                style: const TextStyle(fontSize: 14, color: Colors.black54)),

            const SizedBox(height: 16),

            // 🔹 Botones de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onEdit != null)
                  _buildActionButton(
                    icon: Icons.edit,
                    color: Colors.orange,
                    onTap: onEdit!,
                  ),
                if (onDelete != null)
                  const SizedBox(width: 8),
                if (onDelete != null)
                  _buildActionButton(
                    icon: Icons.delete,
                    color: Colors.redAccent,
                    onTap: onDelete!,
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      {required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}
