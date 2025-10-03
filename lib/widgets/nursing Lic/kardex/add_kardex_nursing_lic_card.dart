import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/nursing%20Lic/kardex_nursing_lic_provider.dart';
import 'package:tusalud/style/app_style.dart';

// Models
import 'package:tusalud/api/response/app/ts_diet_response.dart';
import 'package:tusalud/api/response/app/ts_people_response.dart';
import 'package:tusalud/api/request/app/ts_kardex_request.dart';

// Providers
import 'package:tusalud/providers/admin/diet_admin_provider.dart';
import 'package:tusalud/providers/admin/people_admin_provider.dart';

import '../../../api/tu_salud_api.dart';

class AddKardexNursingLicCard extends StatefulWidget {
  final int patientId; // 👈 nuevo

  const AddKardexNursingLicCard({super.key, required this.patientId});

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
  TsPeopleResponse? _selectedNurse;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentDate = DateFormat("yyyy-MM-dd").format(now);
    _currentHour = DateFormat("HH:mm:ss").format(now);

    // Cargar dietas
    Future.microtask(() =>
        Provider.of<DietAdminProvider>(context, listen: false).loadDiets());

    // Cargar enfermeras (roleId = 2)
    Future.microtask(() =>
        Provider.of<PeopleAdminProvider>(context, listen: false).loadPeopleByRole(2));
  }

  @override
  void dispose() {
    _numberController.dispose();
    _diagnosisController.dispose();
    _actionsController.dispose();
    super.dispose();
  }

void _saveForm() async {
  if (_formKey.currentState!.validate()) {
    final kardexRequest = TsKardexRequest(
      kardexNumber: int.tryParse(_numberController.text) ?? 0,
      kardexDiagnosis: _diagnosisController.text,
      kardexDate: _currentDate,
      kardexHour: _currentHour,
      nursingActions: _actionsController.text,
      patientId: widget.patientId, // 👈 viene de la vista
      nurseId: _selectedNurse?.personId ?? 0, // 👈 enfermera seleccionada
      dietId: _selectedDiet?.dietId ?? 0,
    );

    // 🔹 Provider para llamar a la API
    final kardexProvider = Provider.of<KardexNursingLicProvider>(context, listen: false);

    final response = await TuSaludApi().createKardex(kardexRequest);

    if (response.isSuccess() && response.data != null) {
      // 👌 Refrescar lista de Kardex
      await kardexProvider.loadKardexByPatientAndRole(widget.patientId, 4);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Kardex creado con éxito")),
      );

      Navigator.pop(context); // 👈 ahora vuelve con lista actualizada
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error: ${response.message ?? 'No se pudo crear'}")),
      );
    }
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

              // Fecha y Hora automáticas
              Row(
                children: [
                  Expanded(child: _buildInfoBox(Icons.calendar_today, _currentDate)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildInfoBox(Icons.access_time, _currentHour)),
                ],
              ),
              const SizedBox(height: 16),

              // Dropdown Dieta
              Consumer<DietAdminProvider>(
                builder: (context, dietProvider, _) {
                  if (dietProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (dietProvider.errorMessage != null) {
                    return Text(
                      dietProvider.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    );
                  }
                  if (dietProvider.diets.isEmpty) {
                    return const Text("No hay dietas registradas");
                  }
                  return DropdownButtonFormField<TsDietResponse>(
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
                  );
                },
              ),
              const SizedBox(height: 16),

              // Dropdown Enfermera
              Consumer<PeopleAdminProvider>(
                builder: (context, nurseProvider, _) {
                  if (nurseProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (nurseProvider.errorMessage != null) {
                    return Text(
                      nurseProvider.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    );
                  }
                  if (nurseProvider.people.isEmpty) {
                    return const Text("No hay enfermeras registradas");
                  }
                  return DropdownButtonFormField<TsPeopleResponse>(
                    value: _selectedNurse,
                    items: nurseProvider.people.map((nurse) {
                      final fullName =
                          "${nurse.personName ?? ''} ${nurse.personFahterSurname ?? ''} ${nurse.personMotherSurname ?? ''}";
                      return DropdownMenuItem<TsPeopleResponse>(
                        value: nurse,
                        child: Text(fullName.trim()),
                      );
                    }).toList(),
                    decoration: _inputDecoration("Seleccione Enfermera", Icons.person),
                    onChanged: (value) => setState(() => _selectedNurse = value),
                    validator: (value) => value == null ? "Seleccione una enfermera" : null,
                  );
                },
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
