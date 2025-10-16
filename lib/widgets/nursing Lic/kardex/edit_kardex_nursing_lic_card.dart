import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/api/request/app/ts_kardex_request.dart';
import 'package:tusalud/api/response/app/ts_kardex_response.dart';
import 'package:tusalud/api/response/app/ts_diet_response.dart';
import 'package:tusalud/providers/admin/diet_admin_provider.dart';
import 'package:tusalud/providers/nursing%20Lic/kardex_nursing_lic_provider.dart';
import 'package:tusalud/style/app_style.dart';

class EditKardexNursingLicCard extends StatefulWidget {
  final TsKardexResponse kardex;
  final int patientId;

  const EditKardexNursingLicCard({
    super.key,
    required this.kardex,
    required this.patientId,
  });

  @override
  State<EditKardexNursingLicCard> createState() =>
      _EditKardexNursingLicCardState();
}

class _EditKardexNursingLicCardState extends State<EditKardexNursingLicCard> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _numberController;
  late TextEditingController _diagnosisController;
  late TextEditingController _actionsController;

  late String _currentDate;
  late String _currentHour;
  TsDietResponse? _selectedDiet;

  @override
  void initState() {
    super.initState();

    _numberController =
        TextEditingController(text: widget.kardex.kardexNumber.toString());
    _diagnosisController =
        TextEditingController(text: widget.kardex.kardexDiagnosis ?? "");
    _actionsController =
        TextEditingController(text: widget.kardex.nursingActions ?? "");

    final now = DateTime.now();
    _currentDate = DateFormat("yyyy-MM-dd").format(now);
    _currentHour = DateFormat("HH:mm:ss").format(now);

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

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      final kardexRequest = TsKardexRequest(
        kardexNumber: int.tryParse(_numberController.text) ?? 0,
        kardexDiagnosis: _diagnosisController.text,
        kardexDate: _currentDate,
        kardexHour: _currentHour,
        nursingActions: _actionsController.text,
        patientId: widget.patientId,
        dietId: _selectedDiet?.dietId ?? widget.kardex.dietId ?? 0,
      );

      final kardexProvider =
          Provider.of<KardexNursingLicProvider>(context, listen: false);

      final success =
          await kardexProvider.updateKardex(widget.kardex.kardexId, kardexRequest);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Kardex actualizado correctamente")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Error al actualizar el kardex")),
        );
      }
    }
  }

  InputDecoration _input(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: AppStyle.primary),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppStyle.primary, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Número de Kardex
              TextFormField(
                controller: _numberController,
                keyboardType: TextInputType.number,
                decoration: _input("Número de Kardex", Icons.confirmation_number),
                validator: (v) => v!.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 16),

              // Diagnóstico
              TextFormField(
                controller: _diagnosisController,
                decoration: _input("Diagnóstico", Icons.medical_information),
                validator: (v) => v!.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 16),

              // Fecha y Hora (solo lectura)
              Row(
                children: [
                  Expanded(child: _infoBox(Icons.calendar_today, _currentDate)),
                  const SizedBox(width: 12),
                  Expanded(child: _infoBox(Icons.access_time, _currentHour)),
                ],
              ),
              const SizedBox(height: 16),

              // Dieta
              Consumer<DietAdminProvider>(
                builder: (context, dietProvider, _) {
                  if (dietProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (dietProvider.diets.isEmpty) {
                    return const Text("⚠️ No hay dietas registradas");
                  }

                  final initialDiet = dietProvider.diets.firstWhere(
                    (d) => d.dietId == widget.kardex.dietId,
                    orElse: () => dietProvider.diets.first,
                  );

                  return DropdownButtonFormField<TsDietResponse>(
                    value: _selectedDiet ?? initialDiet,
                    items: dietProvider.diets
                        .map((diet) => DropdownMenuItem<TsDietResponse>(
                              value: diet,
                              child: Text(diet.dietName ?? "Sin nombre"),
                            ))
                        .toList(),
                    decoration:
                        _input("Seleccione una Dieta", Icons.restaurant_menu),
                    onChanged: (v) => setState(() => _selectedDiet = v),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Acciones de Enfermería
              TextFormField(
                controller: _actionsController,
                maxLines: 3,
                decoration: _input("Acciones de Enfermería", Icons.notes),
                validator: (v) => v!.isEmpty ? "Campo requerido" : null,
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.cancel, size: 22),
                      label: const Text(
                        "Cancelar",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.save, size: 22),
                      label: const Text(
                        "Guardar",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: _saveChanges,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoBox(IconData icon, String text) {
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
