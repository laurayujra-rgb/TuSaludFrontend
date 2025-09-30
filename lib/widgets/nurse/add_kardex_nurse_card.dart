import 'package:flutter/material.dart';
import 'package:tusalud/style/app_style.dart';

class AddKardexNurseCard extends StatefulWidget {
  const AddKardexNurseCard({super.key});

  @override
  State<AddKardexNurseCard> createState() => _AddKardexNurseCardState();
}

class _AddKardexNurseCardState extends State<AddKardexNurseCard> {
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final _numberController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _dateController = TextEditingController();
  final _hourController = TextEditingController();
  final _dietIdController = TextEditingController();
  final _actionsController = TextEditingController();

  @override
  void dispose() {
    _numberController.dispose();
    _diagnosisController.dispose();
    _dateController.dispose();
    _hourController.dispose();
    _dietIdController.dispose();
    _actionsController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final request = {
        "kardexNumber": int.tryParse(_numberController.text) ?? 0,
        "kardexDiagnosis": _diagnosisController.text,
        "kardexDate": _dateController.text,
        "kardexHour": _hourController.text,
        "diets": {"dietId": int.tryParse(_dietIdController.text) ?? 0},
        "nursingActions": _actionsController.text,
      };

      debugPrint("Nuevo Kardex: $request");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Kardex preparado para enviar")),
      );

      Navigator.pop(context);
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
                controller: _numberController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("Número de Kardex", Icons.confirmation_number),
                validator: (value) => value!.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _diagnosisController,
                decoration: _inputDecoration("Diagnóstico", Icons.medical_information),
                validator: (value) => value!.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dateController,
                      decoration: _inputDecoration("Fecha (dd-MM-yyyy)", Icons.calendar_today),
                      validator: (value) => value!.isEmpty ? "Campo requerido" : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _hourController,
                      decoration: _inputDecoration("Hora (HH:mm:ss)", Icons.access_time),
                      validator: (value) => value!.isEmpty ? "Campo requerido" : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _dietIdController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("ID de Dieta", Icons.restaurant_menu),
                validator: (value) => value!.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _actionsController,
                maxLines: 3,
                decoration: _inputDecoration("Acciones de Enfermería", Icons.notes),
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
                    "Guardar Kardex",
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
