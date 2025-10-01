import 'package:flutter/material.dart';
import 'package:tusalud/api/response/app/ts_kardex_response.dart';
import 'package:tusalud/style/app_style.dart';

class KardexNursingLicCard extends StatelessWidget {
  final TsKardexResponse kardex;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const KardexNursingLicCard({
    super.key,
    required this.kardex,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Número de Kardex + Diagnóstico
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppStyle.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.assignment, color: AppStyle.primary, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Kardex #${kardex.kardexNumber ?? '-'}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppStyle.primary,
                    ),
                  ),
                ),
                if (onEdit != null)
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blueAccent),
                    onPressed: onEdit,
                  ),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: onDelete,
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // Diagnóstico
            Text(
              kardex.kardexDiagnosis ?? "Sin diagnóstico",
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),

            // Dieta y fecha
            Row(
              children: [
                const Icon(Icons.restaurant_menu, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  kardex.dietName ?? "Sin dieta",
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const Spacer(),
                const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  kardex.kardexDate ?? "",
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Hora + Acciones de enfermería
            Row(
              children: [
                const Icon(Icons.access_time, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  kardex.kardexHour ?? "",
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (kardex.nursingActions != null && kardex.nursingActions!.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  kardex.nursingActions!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
