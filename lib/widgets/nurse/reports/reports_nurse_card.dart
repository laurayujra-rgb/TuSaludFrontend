import 'package:flutter/material.dart';
import 'package:tusalud/api/response/app/ts_reports_response.dart';
import 'package:tusalud/style/app_style.dart';

class ReportNurseCard extends StatelessWidget {
  final TsReportsResponse report;

  const ReportNurseCard({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con ID y estado
            Row(
              children: [
                const Icon(Icons.description, color: AppStyle.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  "Reporte #${report.reportId}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppStyle.textDark,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: report.reportStatus == 1
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    report.reportStatus == 1 ? "Activo" : "Inactivo",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: report.reportStatus == 1
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Detalle del reporte
            Text(
              report.reportDetails ?? "Sin detalles",
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                color: AppStyle.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
