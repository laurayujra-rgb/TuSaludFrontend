import 'package:flutter/material.dart';
import 'package:tusalud/api/response/app/ts_kardex_response.dart';
import 'package:tusalud/style/app_style.dart';

class MedicationKardexNursingLicCard extends StatelessWidget {
  final TsKardexResponse kardex;
  final VoidCallback onTap;

  const MedicationKardexNursingLicCard({
    super.key,
    required this.kardex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Diagnóstico
              Text(
                kardex.kardexDiagnosis ?? "Sin diagnóstico",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppStyle.primary,
                ),
              ),
              const SizedBox(height: 8),

              // 🔹 Enfermera
              if (kardex.nurseName != null && kardex.nurseName!.isNotEmpty)
                Text("👩‍⚕️ Enfermera: ${kardex.nurseName!}"),

              // 🔹 Dieta
              if (kardex.dietName != null && kardex.dietName!.isNotEmpty)
                Text("🍽️ Dieta: ${kardex.dietName!}"),

              // 🔹 Fecha y hora
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(kardex.kardexDate ?? ""),
                  const SizedBox(width: 12),
                  const Icon(Icons.access_time, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(kardex.kardexHour ?? ""),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
