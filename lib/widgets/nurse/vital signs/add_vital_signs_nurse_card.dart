import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/api/request/app/ts_vital_signs_request.dart';
import 'package:tusalud/providers/nurse/vital_signs_provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/api/tu_salud_api.dart';
import 'package:tusalud/views/nurse/vital_signs_ranges.dart';

class AddVitalSignNurseCard extends StatefulWidget {
  final int kardexId;

  const AddVitalSignNurseCard({super.key, required this.kardexId});

  @override
  State<AddVitalSignNurseCard> createState() => _AddVitalSignNurseCardState();
}

class _AddVitalSignNurseCardState extends State<AddVitalSignNurseCard> {
  final _formKey = GlobalKey<FormState>();

  final _tempController = TextEditingController();
  final _pulseController = TextEditingController();
  final _respController = TextEditingController();
  final _bpController = TextEditingController();
  final _o2Controller = TextEditingController();

  int? _patientAge;

  @override
  void dispose() {
    _tempController.dispose();
    _pulseController.dispose();
    _respController.dispose();
    _bpController.dispose();
    _o2Controller.dispose();
    super.dispose();
  }

  // ============================
  // 🔹 Validaciones visuales
  // ============================
  bool _isPulseOutOfRange() {
    if (_patientAge == null) return false;
    final r = VitalSignsRanges.fromAge(_patientAge!);
    final val = int.tryParse(_pulseController.text.trim());
    if (val == null) return false;
    return val < r.minHr || val > r.maxHr;
  }

  bool _isRespOutOfRange() {
    if (_patientAge == null) return false;
    final r = VitalSignsRanges.fromAge(_patientAge!);
    final val = int.tryParse(_respController.text.trim());
    if (val == null) return false;
    return val < r.minResp || val > r.maxResp;
  }

  bool _isBpOutOfRange() {
    if (_patientAge == null) return false;
    final r = VitalSignsRanges.fromAge(_patientAge!);
    final val = int.tryParse(_bpController.text.split('/').first.trim());
    if (val == null) return false;
    return val < r.minBpSys || val > r.maxBpSys;
  }

  bool _isSpo2OutOfRange() {
    if (_patientAge == null) return false;
    final r = VitalSignsRanges.fromAge(_patientAge!);
    final val = int.tryParse(_o2Controller.text.trim());
    if (val == null) return false;
    return val < r.minSpo2 || val > r.maxSpo2;
  }

  bool _isTempOutOfRange() {
    if (_patientAge == null) return false;
    final r = VitalSignsRanges.fromAge(_patientAge!);
    final val = double.tryParse(_tempController.text.trim());
    if (val == null) return false;
    return val < r.minTemp || val > r.maxTemp;
  }

  // ============================
  // 🔹 Guardar formulario
  // ============================
  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;

    final api = TuSaludApi();
    final infoResp = await api.getPatientInfoByKardexId(widget.kardexId);

    if (!infoResp.isSuccess() || infoResp.data == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ No se pudo obtener la información del paciente")),
      );
      return;
    }

    final int age = infoResp.data!.personAge ?? 0;
    setState(() => _patientAge = age);
    final r = VitalSignsRanges.fromAge(age);

    final double? temp = double.tryParse(_tempController.text.trim());
    final int? pulse = int.tryParse(_pulseController.text.trim());
    final int? resp = int.tryParse(_respController.text.trim());
    final int? spo2 = int.tryParse(_o2Controller.text.trim());
    final String bp = _bpController.text.trim();
    final int? bpSys = int.tryParse(bp.split('/').first.trim());

    final List<String> alerts = [];

    if (temp != null && (temp < r.minTemp || temp > r.maxTemp)) {
      alerts.add("• Temperatura: ${temp.toStringAsFixed(1)}°C (rango ${r.minTemp}-${r.maxTemp})");
    }
    if (pulse != null && (pulse < r.minHr || pulse > r.maxHr)) {
      alerts.add("• Ritmo cardíaco: $pulse lpm (rango ${r.minHr}-${r.maxHr})");
    }
    if (bpSys != null && (bpSys < r.minBpSys || bpSys > r.maxBpSys)) {
      alerts.add("• Presión sistólica: $bpSys mmHg (rango ${r.minBpSys}-${r.maxBpSys})");
    }
    if (resp != null && (resp < r.minResp || resp > r.maxResp)) {
      alerts.add("• Frecuencia respiratoria: $resp rpm (rango ${r.minResp}-${r.maxResp})");
    }
    if (spo2 != null && (spo2 < r.minSpo2 || spo2 > r.maxSpo2)) {
      alerts.add("• Saturación O₂: $spo2% (rango ${r.minSpo2}-${r.maxSpo2})");
    }

    if (alerts.isNotEmpty) {
      final continuar = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("⚠️ Valores fuera de rango"),
          content: Text("${alerts.join('\n')}\n\n¿Deseas continuar y guardar de todas formas?"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancelar")),
            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Continuar")),
          ],
        ),
      );
      if (continuar != true) return;
    }

    final now = DateTime.now();
    final request = TsVitalSignsRequest(
      vitalSignsDate: "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
      vitalSignsHour: "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}",
      vitalSignsTemperature: _tempController.text,
      vitalSignsHeartRate: _pulseController.text,
      vitalSignsRespiratoryRate: _respController.text,
      vitalSignsBloodPressure: _bpController.text,
      vitalSignsOxygenSaturation: _o2Controller.text,
      kardexId: widget.kardexId,
    );

    final provider = Provider.of<VitalSignsNurseProvider>(context, listen: false);
    await provider.addVitalSign(request);

    if (provider.errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Signo vital agregado correctamente")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage!)),
      );
    }
  }

  // ============================
  // 🔹 Decoración dinámica
  // ============================
  InputDecoration _inputDecoration(String label, IconData icon, {bool outOfRange = false}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: outOfRange ? Colors.red : AppStyle.primary),
      filled: true,
      fillColor: outOfRange ? Colors.red.shade50 : Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: outOfRange ? Colors.red : AppStyle.primary, width: 1.5),
      ),
    );
  }

  // ============================
  // 🔹 UI principal
  // ============================
  @override
  Widget build(BuildContext context) {
    final ageText = _patientAge != null ? "Edad detectada: $_patientAge años" : "";

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (ageText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(ageText, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                ),

              // Temperatura
              TextFormField(
                controller: _tempController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("Temperatura (°C)", Icons.thermostat, outOfRange: _isTempOutOfRange()),
                validator: (value) => value!.isEmpty ? "Campo requerido" : null,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 14),

              // Pulso
              TextFormField(
                controller: _pulseController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("Pulso (lpm)", Icons.favorite, outOfRange: _isPulseOutOfRange()),
                validator: (value) => value!.isEmpty ? "Campo requerido" : null,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 14),

              // Respiración
              TextFormField(
                controller: _respController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("Frecuencia Respiratoria", Icons.air, outOfRange: _isRespOutOfRange()),
                validator: (value) => value!.isEmpty ? "Campo requerido" : null,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 14),

              // Presión arterial
              TextFormField(
                controller: _bpController,
                decoration: _inputDecoration("Presión Arterial (ej: 120/80)", Icons.monitor_heart, outOfRange: _isBpOutOfRange()),
                validator: (value) => value!.isEmpty ? "Campo requerido" : null,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 14),

              // Saturación de oxígeno
              TextFormField(
                controller: _o2Controller,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("Saturación O₂ (%)", Icons.bloodtype, outOfRange: _isSpo2OutOfRange()),
                validator: (value) => value!.isEmpty ? "Campo requerido" : null,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 20),

              // Botón guardar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyle.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  icon: const Icon(Icons.save, size: 22),
                  label: const Text("Guardar Signo Vital", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  onPressed: _saveForm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
