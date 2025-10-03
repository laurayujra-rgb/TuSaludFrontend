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
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Header: Título + Botones de acción
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppStyle.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text("📋",
                      style: TextStyle(fontSize: 26)), // Emoji en vez de ícono
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    "Kardex",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
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
            const SizedBox(height: 10),

            // 🔹 Diagnóstico
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("🩺 ",
                    style: TextStyle(fontSize: 20)), // emoji diagnóstico
                Expanded(
                  child: Text(
                    kardex.kardexDiagnosis ?? "Sin diagnóstico",
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 🔹 Enfermera asignada
            if (kardex.nurseName != null && kardex.nurseName!.isNotEmpty)
              Row(
                children: [
                  const Text("👩‍⚕️ ",
                      style: TextStyle(fontSize: 20)), // emoji enfermera
                  Expanded(
                    child: Text(
                      kardex.nurseName!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            if (kardex.nurseName != null && kardex.nurseName!.isNotEmpty)
              const SizedBox(height: 10),

            // 🔹 Dieta + Fecha
            Row(
              children: [
                const Text("🍽️ ", style: TextStyle(fontSize: 20)),
                Text(
                  kardex.dietName ?? "Sin dieta",
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const Spacer(),
                const Text("📅 ", style: TextStyle(fontSize: 20)),
                Text(
                  kardex.kardexDate ?? "",
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 🔹 Hora
            Row(
              children: [
                const Text("⏰ ", style: TextStyle(fontSize: 20)),
                Text(
                  kardex.kardexHour ?? "",
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 🔹 Acciones de enfermería
            if (kardex.nursingActions != null &&
                kardex.nursingActions!.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("✍️ ", style: TextStyle(fontSize: 20)),
                    Expanded(
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
          ],
        ),
      ),
    );
  }
}
