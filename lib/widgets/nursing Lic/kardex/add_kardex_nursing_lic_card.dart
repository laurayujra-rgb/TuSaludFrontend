import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/api/response/app/ts_diet_response.dart';
import 'package:tusalud/providers/admin/diet_admin_provider.dart';

class AddKardexNursingLicCard extends StatefulWidget {
  const AddKardexNursingLicCard({super.key});

  @override
  State<AddKardexNursingLicCard> createState() => _AddKardexNursingLicCardState();
}

class _AddKardexNursingLicCardState extends State<AddKardexNursingLicCard> {
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final _numberController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _actionsController = TextEditingController();

  String _currentDate = "";
  String _currentHour = "";
  TsDietResponse? _selectedDiet;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentDate = DateFormat("yyyy-MM-dd").format(now);
    _currentHour = DateFormat("HH:mm:ss").format(now);

    // 🔹 Cargar dietas desde el Provider
    Future.microtask(() =>
        Provider.of<DietAdminProvider>(context, listen: false).loadDiets());
  }

  @override
  void dispose() {
    _numberController.dispose();
    _diagnosisController.dispose();
    _actionsController.dispose();
    super.dispose();
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      final request = {
        "kardexNumber": int.tryParse(_numberController.text) ?? 0,
        "kardexDiagnosis": _diagnosisController.text,
        "kardexDate": _currentDate,
        "kardexHour": _currentHour,
        "diets": {"dietId": _selectedDiet?.dietId ?? 0},
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
    return Consumer<DietAdminProvider>(
      builder: (context, dietProvider, _) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 6,
          shadowColor: Colors.black.withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Número de Kardex
                  TextFormField(
                    controller: _numberController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration("Número de Kardex", Icons.confirmation_number),
                    validator: (value) => value!.isEmpty ? "Campo requerido" : null,
                  ),
                  const SizedBox(height: 16),

                  // Diagnóstico
                  TextFormField(
                    controller: _diagnosisController,
                    decoration: _inputDecoration("Diagnóstico", Icons.medical_information),
                    validator: (value) => value!.isEmpty ? "Campo requerido" : null,
                  ),
                  const SizedBox(height: 16),

                  // Fecha y Hora (auto)
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoBox(Icons.calendar_today, _currentDate),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoBox(Icons.access_time, _currentHour),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Dropdown Dieta con Provider
                  if (dietProvider.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (dietProvider.errorMessage != null)
                    Text(
                      dietProvider.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    )
                  else
                    DropdownButtonFormField<TsDietResponse>(
                      value: _selectedDiet,
                      items: dietProvider.diets.map((diet) {
                        return DropdownMenuItem<TsDietResponse>(
                          value: diet,
                          child: Text(diet.dietName ?? "Sin nombre"),
                        );
                      }).toList(),
                      decoration: _inputDecoration("Seleccione una Dieta", Icons.restaurant_menu),
                      onChanged: (value) => setState(() => _selectedDiet = value),
                      validator: (value) => value == null ? "Seleccione una dieta" : null,
                    ),

                  const SizedBox(height: 16),

                  // Acciones de Enfermería
                  TextFormField(
                    controller: _actionsController,
                    maxLines: 3,
                    decoration: _inputDecoration("Acciones de Enfermería", Icons.notes),
                    validator: (value) => value!.isEmpty ? "Campo requerido" : null,
                  ),
                  const SizedBox(height: 24),

                  // Botones
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red, width: 1.5),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          icon: const Icon(Icons.cancel, size: 22),
                          label: const Text("Cancelar", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          icon: const Icon(Icons.save, size: 22),
                          label: const Text("Guardar", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          onPressed: _saveForm,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoBox(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(14),
        color: Colors.grey.shade50,
      ),
      child: Row(
        children: [
          Icon(icon, color: AppStyle.primary),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}
