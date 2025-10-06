import 'package:flutter/material.dart';
import 'package:tusalud/api/response/app/ts_vital_signs_response.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/views/nurse/vital_signs_ranges.dart';
import 'package:tusalud/api/tu_salud_api.dart';

class VitalSignsNurseCard extends StatefulWidget {
  final TsVitalSignsResponse vitalSign;

  const VitalSignsNurseCard({super.key, required this.vitalSign});

  @override
  State<VitalSignsNurseCard> createState() => _VitalSignsNurseCardState();
}

class _VitalSignsNurseCardState extends State<VitalSignsNurseCard> {
  int? _patientAge;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPatientInfo();
  }

  Future<void> _fetchPatientInfo() async {
    try {
      final api = TuSaludApi();
      final response =
          await api.getPatientInfoByKardexId(widget.vitalSign.kardexId);

      if (!mounted) return; // evita errores si se desmonta antes de setState

      if (response.isSuccess() && response.data?.personAge != null) {
        setState(() {
          _patientAge = response.data!.personAge;
        });
      } else {
        setState(() {
          _patientAge = 25;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _patientAge = 25;
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  Color _getColorForValue({
    required num value,
    required num min,
    required num max,
  }) {
    if (value < min || value > max) return Colors.red.shade400;
    if ((value - min).abs() < 2 || (value - max).abs() < 2) {
      return Colors.orange.shade400;
    }
    return Colors.green.shade600;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),
      );
    }

    final int age = _patientAge ?? 25;
    final r = VitalSignsRanges.fromAge(age);

    final double? temp =
        double.tryParse(widget.vitalSign.vitalSignsTemperature ?? "");
    final int? pulse =
        int.tryParse(widget.vitalSign.vitalSignsHeartRate ?? "");
    final int? resp =
        int.tryParse(widget.vitalSign.vitalSignsRespiratoryRate ?? "");
    final int? spo2 =
        int.tryParse(widget.vitalSign.vitalSignsOxygenSaturation ?? "");
    final int? bpSys = int.tryParse(
        (widget.vitalSign.vitalSignsBloodPressure ?? "").split('/').first);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shadowColor: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Encabezado (fecha + hora)
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    size: 16, color: AppStyle.primary),
                const SizedBox(width: 6),
                Text(
                  widget.vitalSign.vitalSignsDate ?? '--',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const Spacer(),
                const Icon(Icons.access_time,
                    size: 16, color: Colors.blueGrey),
                const SizedBox(width: 4),
                Text(widget.vitalSign.vitalSignsHour ?? '--',
                    style: const TextStyle(fontSize: 13)),
              ],
            ),

            const SizedBox(height: 10),

            // 🔹 Enfermera responsable
            if (widget.vitalSign.vitalSignsNurse != null &&
                widget.vitalSign.vitalSignsNurse!.isNotEmpty)
              Row(
                children: [
                  const Icon(Icons.person_outline,
                      size: 18, color: AppStyle.primary),
                  const SizedBox(width: 6),
                  Text(
                    "Registrado por: ",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    widget.vitalSign.vitalSignsNurse!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppStyle.primary,
                      fontSize: 13.5,
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 14),

            // 🔹 Signos vitales principales
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _chipValue(
                  "🌡 Temp",
                  "${widget.vitalSign.vitalSignsTemperature ?? '--'} °C",
                  color: temp != null
                      ? _getColorForValue(
                          value: temp, min: r.minTemp, max: r.maxTemp)
                      : AppStyle.primary,
                ),
                _chipValue(
                  "❤️ Pulso",
                  "${widget.vitalSign.vitalSignsHeartRate ?? '--'} lpm",
                  color: pulse != null
                      ? _getColorForValue(
                          value: pulse, min: r.minHr, max: r.maxHr)
                      : AppStyle.primary,
                ),
                _chipValue(
                  "💨 Resp",
                  "${widget.vitalSign.vitalSignsRespiratoryRate ?? '--'} rpm",
                  color: resp != null
                      ? _getColorForValue(
                          value: resp, min: r.minResp, max: r.maxResp)
                      : AppStyle.primary,
                ),
                _chipValue(
                  "🩸 PA",
                  "${widget.vitalSign.vitalSignsBloodPressure ?? '--'}",
                  color: bpSys != null
                      ? _getColorForValue(
                          value: bpSys,
                          min: r.minBpSys,
                          max: r.maxBpSys,
                        )
                      : AppStyle.primary,
                ),
                _chipValue(
                  "O₂ Sat",
                  "${widget.vitalSign.vitalSignsOxygenSaturation ?? '--'} %",
                  color: spo2 != null
                      ? _getColorForValue(
                          value: spo2, min: r.minSpo2, max: r.maxSpo2)
                      : AppStyle.primary,
                ),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              "Edad del paciente: $age años",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 10),

            // 🔹 Estado visual
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: widget.vitalSign.vitalSignsStatus == 1
                      ? Colors.green.shade100
                      : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.vitalSign.vitalSignsStatus == 1
                      ? "Activo"
                      : "Inactivo",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: widget.vitalSign.vitalSignsStatus == 1
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

  Widget _chipValue(String label, String value, {required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
