import 'package:flutter/material.dart';
import 'package:tusalud/api/response/app/ts_vital_signs_response.dart';
import 'package:tusalud/style/app_style.dart';

class VitalSignsNurseCard extends StatelessWidget {
  final TsVitalSignsResponse vitalSign;

  const VitalSignsNurseCard({
    super.key,
    required this.vitalSign,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.blue.shade700),
                const SizedBox(width: 6),
                Text(
                  vitalSign.vitalSignsDate ?? '--',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const Spacer(),
                Icon(Icons.access_time, size: 16, color: Colors.blueGrey),
                const SizedBox(width: 4),
                Text(vitalSign.vitalSignsHour ?? '--',
                    style: const TextStyle(fontSize: 13)),
              ],
            ),
            const SizedBox(height: 12),

            // Valores principales
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _chipValue("Temp", "${vitalSign.vitalSignsTemperature ?? '--'} °C"),
                _chipValue("Pulso", vitalSign.vitalSignsHeartRate ?? '--'),
                _chipValue("Resp", vitalSign.vitalSignsRespiratoryRate ?? '--'),
                _chipValue("PA", vitalSign.vitalSignsBloodPressure ?? '--'),
                _chipValue("SatO₂", "${vitalSign.vitalSignsOxygenSaturation ?? '--'} %"),
              ],
            ),

            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: vitalSign.vitalSignsStatus == 1
                      ? Colors.green.shade100
                      : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  vitalSign.vitalSignsStatus == 1 ? "Activo" : "Inactivo",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: vitalSign.vitalSignsStatus == 1
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chipValue(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppStyle.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppStyle.primary.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            spreadRadius: 0,
            offset: const Offset(0, 2),
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppStyle.primary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
