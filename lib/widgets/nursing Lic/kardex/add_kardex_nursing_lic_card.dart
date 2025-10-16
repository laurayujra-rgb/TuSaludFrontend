import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/api/request/app/ts_kardex_request.dart';
import 'package:tusalud/api/response/app/ts_diet_response.dart';
import 'package:tusalud/providers/admin/diet_admin_provider.dart';
import 'package:tusalud/providers/app/profile_provider.dart';
import 'package:tusalud/providers/nursing%20Lic/kardex_nursing_lic_provider.dart';
import 'package:tusalud/style/app_style.dart';
import '../../../api/tu_salud_api.dart';

class AddKardexNursingLicCard extends StatefulWidget {
  final int patientId;

  const AddKardexNursingLicCard({super.key, required this.patientId});

  @override
  State<AddKardexNursingLicCard> createState() => _AddKardexNursingLicCardState();
}

class _AddKardexNursingLicCardState extends State<AddKardexNursingLicCard> {
  final _formKey = GlobalKey<FormState>();
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

    Future.microtask(() {
      Provider.of<DietAdminProvider>(context, listen: false).loadDiets();
      Provider.of<ProfileProvider>(context, listen: false).loadCurrentUserData();
    });
  }

  @override
  void dispose() {
    _numberController.dispose();
    _diagnosisController.dispose();
    _actionsController.dispose();
    super.dispose();
  }

Future<void> _saveForm() async {
  if (!_formKey.currentState!.validate()) return;

  final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
  final currentUser = profileProvider.currentUser;

  if (currentUser == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("No se pudo obtener el perfil de la enfermera.")),
    );
    return;
  }

  // 👩‍⚕️ Nombre + Rol desde el perfil
  final nurseFullName = "${currentUser.personName ?? ''} ${currentUser.personFahterSurname ?? ''} ${currentUser.personMotherSurname ?? ''}".trim();
  final nurseRole = currentUser.role?.roleName ?? '';

  // Combina nombre + rol en un solo texto (por ejemplo: “María Pérez - Enfermera Licenciada”)
  final nurseDisplay = nurseRole.isNotEmpty
      ? "$nurseFullName - $nurseRole"
      : nurseFullName;

  final kardexRequest = TsKardexRequest(
    kardexNumber: int.tryParse(_numberController.text) ?? 0,
    kardexDiagnosis: _diagnosisController.text,
    kardexDate: _currentDate,
    kardexHour: _currentHour,
    nursingActions: _actionsController.text,
    patientId: widget.patientId,
    dietId: _selectedDiet?.dietId ?? 0,
    nurseLic: nurseDisplay, // ✅ Se envía nombre + rol
  );

  final response = await TuSaludApi().createKardex(kardexRequest);

  if (response.isSuccess() && response.data != null) {
    final kardexProvider = Provider.of<KardexNursingLicProvider>(context, listen: false);
    await kardexProvider.loadKardexByPatientAndRole(widget.patientId, 4);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Kardex creado con éxito")),
    );
    Navigator.pop(context);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("❌ Error: ${response.message ?? 'No se pudo crear'}")),
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
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: AppStyle.primary, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final user = profileProvider.currentUser;

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
              if (user != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppStyle.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person, color: AppStyle.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Licenciada: ${user.personName ?? ''} ${user.personFahterSurname ?? ''}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppStyle.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              // 🔹 Campos del formulario
              TextFormField(
                controller: _numberController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("Número de Kardex", Icons.confirmation_number),
                validator: (v) => v!.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _diagnosisController,
                decoration: _inputDecoration("Diagnóstico", Icons.medical_information),
                validator: (v) => v!.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildInfoBox(Icons.calendar_today, _currentDate)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildInfoBox(Icons.access_time, _currentHour)),
                ],
              ),
              const SizedBox(height: 16),

              // Dietas
              Consumer<DietAdminProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading) return const CircularProgressIndicator();
                  if (provider.diets.isEmpty) return const Text("No hay dietas disponibles");

                  return DropdownButtonFormField<TsDietResponse>(
                    value: _selectedDiet,
                    items: provider.diets.map((d) {
                      return DropdownMenuItem(value: d, child: Text(d.dietName ?? ""));
                    }).toList(),
                    decoration: _inputDecoration("Seleccione una Dieta", Icons.restaurant_menu),
                    onChanged: (v) => setState(() => _selectedDiet = v),
                    validator: (v) => v == null ? "Seleccione una dieta" : null,
                  );
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _actionsController,
                maxLines: 3,
                decoration: _inputDecoration("Acciones de Enfermería", Icons.notes),
                validator: (v) => v!.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: _saveForm,
                icon: const Icon(Icons.save),
                label: const Text("Guardar Kardex"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyle.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
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
