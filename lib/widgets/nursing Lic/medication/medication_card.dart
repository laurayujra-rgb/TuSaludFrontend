import 'package:flutter/material.dart';
import 'package:tusalud/api/response/app/ts_kardex_medicine_response.dart';
import 'package:tusalud/style/app_style.dart';

class MedicationCard extends StatelessWidget {
  final TsMedicationKardexResponse medication;

  const MedicationCard({super.key, required this.medication});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Nombre del medicamento
          Text(
            medication.medicineName ?? "Medicamento",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppStyle.primary,
            ),
          ),
          const SizedBox(height: 12),

          // 🔹 Dosis
          Row(
            children: [
              const Icon(Icons.medication_outlined, color: AppStyle.primary, size: 22),
              const SizedBox(width: 8),
              Text(
                medication.dose ?? "-",
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 🔹 Frecuencia
          Row(
            children: [
              const Icon(Icons.schedule, color: Colors.blueAccent, size: 22),
              const SizedBox(width: 8),
              Text(
                medication.frequency ?? "-",
                style: const TextStyle(fontSize: 15, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 🔹 Vía de administración
          Row(
            children: [
              const Icon(Icons.local_hospital, color: Colors.teal, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  medication.routeNote ?? "-",
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // 🔹 Notas
          if (medication.notes != null && medication.notes!.isNotEmpty)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.note_alt_outlined, color: Colors.orange, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    medication.notes!,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 10),

          // 🔹 Enfermera que registró
          if (medication.nurseLic != null && medication.nurseLic!.isNotEmpty)
            Row(
              children: [
                const Icon(Icons.person, color: AppStyle.primary, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    medication.nurseLic!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppStyle.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
