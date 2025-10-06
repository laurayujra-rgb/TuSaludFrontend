import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/api/request/app/ts_vital_signs_request.dart';
import 'package:tusalud/api/tu_salud_api.dart';
import 'package:tusalud/providers/nurse/vital_signs_provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/views/nurse/vital_signs_ranges.dart';
import 'package:tusalud/providers/auth/user_provider.dart';

enum _FieldStatus { neutral, ok, warn, bad }

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

  bool _isSaving = false;
  int? _patientAge; // cache de edad
  VitalSignsRanges? _ranges;

  // estado visual por campo
  final Map<String, _FieldStatus> _status = {
    'temp': _FieldStatus.neutral,
    'pulse': _FieldStatus.neutral,
    'resp': _FieldStatus.neutral,
    'bp': _FieldStatus.neutral,
    'o2': _FieldStatus.neutral,
  };

  @override
  void initState() {
    super.initState();
    _loadAge();
    // listeners para repintar al teclear
    _tempController.addListener(_recomputeStatuses);
    _pulseController.addListener(_recomputeStatuses);
    _respController.addListener(_recomputeStatuses);
    _bpController.addListener(_recomputeStatuses);
    _o2Controller.addListener(_recomputeStatuses);
  }

  @override
  void dispose() {
    _tempController.dispose();
    _pulseController.dispose();
    _respController.dispose();
    _bpController.dispose();
    _o2Controller.dispose();
    super.dispose();
  }

  Future<void> _loadAge() async {
    try {
      final api = TuSaludApi();
      final info = await api.getPatientInfoByKardexId(widget.kardexId);
      if (!mounted) return;
      final age = (info.isSuccess() ? (info.data?.personAge ?? 25) : 25);
      setState(() {
        _patientAge = age;
        _ranges = VitalSignsRanges.fromAge(age);
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _patientAge = 25;
        _ranges = VitalSignsRanges.fromAge(25);
      });
    }
  }

  void _recomputeStatuses() {
    if (_ranges == null) return;

    // temperatura
    final t = double.tryParse(_tempController.text.trim());
    _status['temp'] = _judgeDouble(t, _ranges!.minTemp, _ranges!.maxTemp, warnDelta: 0.5);

    // pulso
    final hr = int.tryParse(_pulseController.text.trim());
    _status['pulse'] = _judgeInt(hr, _ranges!.minHr, _ranges!.maxHr);

    // resp
    final rr = int.tryParse(_respController.text.trim());
    _status['resp'] = _judgeInt(rr, _ranges!.minResp, _ranges!.maxResp);

    // PA (solo sistólica)
    final bpText = _bpController.text.trim();
    final sys = int.tryParse(bpText.split('/').first.trim());
    _status['bp'] = _judgeInt(sys, _ranges!.minBpSys, _ranges!.maxBpSys);

    // SpO2
    final spo2 = int.tryParse(_o2Controller.text.trim());
    // Para SpO₂, si 90–94 => warn; <90 => bad; ≥95 ok
    if (spo2 == null) {
      _status['o2'] = _FieldStatus.neutral;
    } else if (spo2 < _ranges!.minSpo2) {
      _status['o2'] = (spo2 >= 90) ? _FieldStatus.warn : _FieldStatus.bad;
    } else if (spo2 > _ranges!.maxSpo2) {
      _status['o2'] = _FieldStatus.warn; // >100%, tratar como advertencia
    } else {
      _status['o2'] = _FieldStatus.ok;
    }

    if (mounted) setState(() {});
  }

  _FieldStatus _judgeInt(int? v, int min, int max, {int warnDelta = 2}) {
    if (v == null) return _FieldStatus.neutral;
    if (v < min || v > max) return _FieldStatus.bad;
    if ((v - min).abs() <= warnDelta || (v - max).abs() <= warnDelta) {
      return _FieldStatus.warn;
    }
    return _FieldStatus.ok;
    }

  _FieldStatus _judgeDouble(double? v, double min, double max, {double warnDelta = 0.3}) {
    if (v == null) return _FieldStatus.neutral;
    if (v < min || v > max) return _FieldStatus.bad;
    if ((v - min).abs() <= warnDelta || (v - max).abs() <= warnDelta) {
      return _FieldStatus.warn;
    }
    return _FieldStatus.ok;
  }

  Color _bgFor(_FieldStatus s) {
    switch (s) {
      case _FieldStatus.ok:
        return Colors.green.shade50;
      case _FieldStatus.warn:
        return Colors.amber.shade50;
      case _FieldStatus.bad:
        return Colors.red.shade50;
      case _FieldStatus.neutral:
      default:
        return Colors.grey.shade50;
    }
  }

  Color _borderFor(_FieldStatus s) {
    switch (s) {
      case _FieldStatus.ok:
        return Colors.green.shade300;
      case _FieldStatus.warn:
        return Colors.amber.shade300;
      case _FieldStatus.bad:
        return Colors.red.shade300;
      case _FieldStatus.neutral:
      default:
        return Colors.grey.shade300;
    }
  }

  Color _iconFor(_FieldStatus s) {
    switch (s) {
      case _FieldStatus.ok:
        return Colors.green.shade600;
      case _FieldStatus.warn:
        return Colors.amber.shade700;
      case _FieldStatus.bad:
        return Colors.red.shade600;
      case _FieldStatus.neutral:
      default:
        return AppStyle.primary;
    }
  }

  String _rangeTextNum(num min, num max, {String unit = ''}) {
    return unit.isEmpty ? '$min–$max' : '$min–$max $unit';
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_ranges == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cargando datos del paciente…')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Nombre enfermera desde UserProvider
      final user = Provider.of<UserProvider>(context, listen: false);
      final nurseName = '${user.name ?? ''} ${user.lastName ?? ''}'.trim();

      final age = _patientAge ?? 25;
      final r = _ranges!;

      // Parse valores
      final temp = double.tryParse(_tempController.text.trim());
      final hr = int.tryParse(_pulseController.text.trim());
      final rr = int.tryParse(_respController.text.trim());
      final bpSys = int.tryParse(_bpController.text.split('/').first.trim());
      final spo2 = int.tryParse(_o2Controller.text.trim());

      // Construir alertas
      final List<_Anomaly> anomalies = [];
      if (temp != null && (temp < r.minTemp || temp > r.maxTemp)) {
        anomalies.add(_Anomaly('Temperatura', '$temp °C',
            _rangeTextNum(r.minTemp, r.maxTemp, unit: '°C'), Icons.thermostat));
      }
      if (hr != null && (hr < r.minHr || hr > r.maxHr)) {
        anomalies.add(_Anomaly('Pulso', '$hr lpm',
            _rangeTextNum(r.minHr, r.maxHr, unit: 'lpm'), Icons.favorite));
      }
      if (rr != null && (rr < r.minResp || rr > r.maxResp)) {
        anomalies.add(_Anomaly('Respiración', '$rr rpm',
            _rangeTextNum(r.minResp, r.maxResp, unit: 'rpm'), Icons.air));
      }
      if (bpSys != null && (bpSys < r.minBpSys || bpSys > r.maxBpSys)) {
        anomalies.add(_Anomaly('PA Sistólica', '$bpSys mmHg',
            _rangeTextNum(r.minBpSys, r.maxBpSys, unit: 'mmHg'), Icons.monitor_heart));
      }
      if (spo2 != null && (spo2 < r.minSpo2 || spo2 > r.maxSpo2)) {
        anomalies.add(_Anomaly('Saturación O₂', '$spo2 %',
            _rangeTextNum(r.minSpo2, r.maxSpo2, unit: '%'), Icons.bloodtype));
      }

      // Si hay anomalías → dialogo bonito
      if (anomalies.isNotEmpty) {
        final proceed = await _showAnomaliesDialog(context, age, nurseName, anomalies);
        if (proceed != true) {
          setState(() => _isSaving = false);
          return;
        }
      }

      // Guardar
      final now = DateTime.now();
      final req = TsVitalSignsRequest(
        vitalSignsDate: "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
        vitalSignsHour: "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}",
        vitalSignsTemperature: _tempController.text,
        vitalSignsHeartRate: _pulseController.text,
        vitalSignsRespiratoryRate: _respController.text,
        vitalSignsBloodPressure: _bpController.text,
        vitalSignsOxygenSaturation: _o2Controller.text,
        vitalSignsNurse: nurseName, // <-- se enviará como nureseName en toJson()
        kardexId: widget.kardexId,
      );

      final provider = Provider.of<VitalSignsNurseProvider>(context, listen: false);
      await provider.addVitalSign(req);

      if (provider.errorMessage == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Signo vital agregado correctamente")),
        );
        Navigator.pop(context, true);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(provider.errorMessage!)),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al guardar: $e")),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<bool?> _showAnomaliesDialog(
    BuildContext context,
    int age,
    String nurseName,
    List<_Anomaly> anomalies,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          titlePadding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
          contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          actionsPadding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 26),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  "Valores fuera de rango",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _chipInfo("Edad: $age años", Icons.cake, Colors.blueGrey),
                  if (nurseName.isNotEmpty)
                    _chipInfo("Enfermera: $nurseName", Icons.person, Colors.purple),
                ],
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 240),
                child: SingleChildScrollView(
                  child: Column(
                    children: anomalies.map((a) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(a.icon, color: Colors.red.shade400),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(a.label,
                                      style: TextStyle(
                                          color: Colors.red.shade700,
                                          fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 2),
                                  Text("Ingresado: ${a.value}",
                                      style: const TextStyle(fontSize: 13.5)),
                                  Text("Rango esperado: ${a.expected}",
                                      style: const TextStyle(fontSize: 12.5, color: Colors.black54)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "¿Deseas continuar y guardar de todas formas?",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text("Revisar"),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyle.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(120, 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => Navigator.pop(ctx, true),
              icon: const Icon(Icons.check),
              label: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  Widget _chipInfo(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  InputDecoration _dec({
    required String label,
    required IconData icon,
    required _FieldStatus status,
    String? suffixText,
    String? helperText,
  }) {
    final borderColor = _borderFor(status);
    final iconColor = _iconFor(status);
    return InputDecoration(
      labelText: label,               // etiquetas cortas para no desbordar
      suffixText: suffixText,         // unidades aquí (no en label)
      prefixIcon: Icon(icon, color: iconColor),
      filled: true,
      isDense: true,
      fillColor: _bgFor(status),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: iconColor, width: 1.6),
      ),
      helperText: helperText,
      helperStyle: TextStyle(
        color: status == _FieldStatus.bad
            ? Colors.red.shade600
            : status == _FieldStatus.warn
                ? Colors.amber.shade800
                : Colors.black54,
        fontSize: 12.5,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final age = _patientAge;
    final r = _ranges;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          if (age != null)
            Align(
              alignment: Alignment.centerLeft,
              child: _chipInfo("Edad detectada: $age años", Icons.cake, Colors.blueGrey),
            ),
          const SizedBox(height: 10),

          // Temperatura
          TextFormField(
            controller: _tempController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: _dec(
              label: "Temperatura",
              icon: Icons.thermostat,
              status: _status['temp']!,
              suffixText: "°C",
              helperText: r != null ? "Rango esperado: ${_rangeTextNum(r.minTemp, r.maxTemp, unit: '°C')}" : null,
            ),
            validator: (v) => (v == null || v.isEmpty) ? "Campo obligatorio" : null,
          ),
          const SizedBox(height: 12),

          // Pulso
          TextFormField(
            controller: _pulseController,
            keyboardType: TextInputType.number,
            decoration: _dec(
              label: "Pulso",
              icon: Icons.favorite,
              status: _status['pulse']!,
              suffixText: "lpm",
              helperText: r != null ? "Rango esperado: ${_rangeTextNum(r.minHr, r.maxHr, unit: 'lpm')}" : null,
            ),
            validator: (v) => (v == null || v.isEmpty) ? "Campo obligatorio" : null,
          ),
          const SizedBox(height: 12),

          // Respiración
          TextFormField(
            controller: _respController,
            keyboardType: TextInputType.number,
            decoration: _dec(
              label: "Respiración",
              icon: Icons.air,
              status: _status['resp']!,
              suffixText: "rpm",
              helperText: r != null ? "Rango esperado: ${_rangeTextNum(r.minResp, r.maxResp, unit: 'rpm')}" : null,
            ),
            validator: (v) => (v == null || v.isEmpty) ? "Campo obligatorio" : null,
          ),
          const SizedBox(height: 12),

          // Presión arterial
          TextFormField(
            controller: _bpController,
            keyboardType: TextInputType.number,
            decoration: _dec(
              label: "PA (S/D)",
              icon: Icons.monitor_heart,
              status: _status['bp']!,
              suffixText: "mmHg",
              helperText: r != null ? "Sistólica esperada: ${_rangeTextNum(r.minBpSys, r.maxBpSys, unit: 'mmHg')}" : null,
            ),
            validator: (v) => (v == null || v.isEmpty) ? "Campo obligatorio" : null,
          ),
          const SizedBox(height: 12),

          // Saturación O2
          TextFormField(
            controller: _o2Controller,
            keyboardType: TextInputType.number,
            decoration: _dec(
              label: "Sat O₂",
              icon: Icons.bloodtype,
              status: _status['o2']!,
              suffixText: "%",
              helperText: r != null ? "Rango esperado: ${_rangeTextNum(r.minSpo2, r.maxSpo2, unit: '%')}" : null,
            ),
            validator: (v) => (v == null || v.isEmpty) ? "Campo obligatorio" : null,
          ),

          const SizedBox(height: 18),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppStyle.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: _isSaving
                  ? const SizedBox(
                      height: 18, width: 18,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(_isSaving ? "Guardando..." : "Guardar registro",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              onPressed: _isSaving ? null : _saveForm,
            ),
          ),
        ],
      ),
    );
  }
}

class _Anomaly {
  final String label;
  final String value;
  final String expected;
  final IconData icon;
  _Anomaly(this.label, this.value, this.expected, this.icon);
}
