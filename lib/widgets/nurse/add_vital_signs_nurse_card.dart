import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/api/request/app/ts_vital_signs_request.dart';
import 'package:tusalud/providers/nurse/vital_signs_provider.dart';
import 'package:tusalud/style/app_style.dart';

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

  @override
  void dispose() {
    _tempController.dispose();
    _pulseController.dispose();
    _respController.dispose();
    _bpController.dispose();
    _o2Controller.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) return;

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
      Navigator.pop(context, true); // <- regresa y refresca
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage!)),
      );
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppStyle.primary),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppStyle.primary, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tempController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("Temperatura (°C)", Icons.thermostat),
                validator: (value) => value!.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _pulseController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("Pulso (lpm)", Icons.favorite),
                validator: (value) => value!.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _respController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("Frecuencia Respiratoria", Icons.air),
                validator: (value) => value!.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _bpController,
                decoration: _inputDecoration("Presión Arterial", Icons.monitor_heart),
                validator: (value) => value!.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _o2Controller,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("Saturación O₂ (%)", Icons.bloodtype),
                validator: (value) => value!.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyle.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.save, size: 22),
                  label: const Text(
                    "Guardar Signo Vital",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
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
