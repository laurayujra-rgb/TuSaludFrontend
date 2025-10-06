import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/api/request/app/ts_medication_request.dart';
import 'package:tusalud/api/response/app/ts_medication_response.dart';
import 'package:tusalud/api/tu_salud_api.dart';
import 'package:tusalud/providers/admin/medicine_nurse_provider.dart';
import 'package:tusalud/providers/admin/via_admin_provider.dart';
import 'package:tusalud/style/app_style.dart';

class EditMedicineAdminCard extends StatefulWidget {
  final TsMedicineResponse medicine;

  const EditMedicineAdminCard({super.key, required this.medicine});

  @override
  State<EditMedicineAdminCard> createState() => _EditMedicineAdminCardState();
}

class _EditMedicineAdminCardState extends State<EditMedicineAdminCard> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _labController = TextEditingController();
  bool _isSaving = false;
  int? _selectedViaId;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.medicine.medicineName ?? '';
    _labController.text = widget.medicine.medicineLaboratory ?? '';
    _selectedViaId = widget.medicine.via.viaId;

    Future.microtask(() =>
        Provider.of<ViaAdminProvider>(context, listen: false).loadVias());
  }

  @override
  Widget build(BuildContext context) {
    final medicineProvider = context.watch<MedicineNurseProvider>();
    final viaProvider = context.watch<ViaAdminProvider>();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.medical_services_rounded,
                  color: AppStyle.primary, size: 48),
              const SizedBox(height: 12),
              const Text(
                "Editar Medicamento",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              // 🔹 Campo: Nombre del medicamento
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nombre del medicamento",
                  prefixIcon: Icon(Icons.edit_note_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Ingrese un nombre válido";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // 🔹 Campo: Laboratorio
              TextFormField(
                controller: _labController,
                decoration: const InputDecoration(
                  labelText: "Laboratorio",
                  prefixIcon: Icon(Icons.factory_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Ingrese un laboratorio válido";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // 🔹 Selector de vía
              DropdownButtonFormField<int>(
                value: _selectedViaId,
                decoration: const InputDecoration(
                  labelText: "Vía de administración",
                  prefixIcon: Icon(Icons.route_outlined),
                ),
                items: viaProvider.vias.map((via) {
                  return DropdownMenuItem<int>(
                    value: via.viaId,
                    child: Text(via.viaName ?? "Sin nombre"),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedViaId = value),
                validator: (value) =>
                    value == null ? "Seleccione una vía" : null,
              ),

              const SizedBox(height: 40),

              // 🔹 Botón Guardar cambios
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: _isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Icon(Icons.save_alt, color: Colors.white),
                  label: const Text(
                    "Guardar cambios",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyle.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _isSaving
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _isSaving = true);

                            final request = TsMedicineRequest(
                              medicineName: _nameController.text.trim(),
                              medicineLaboratory: _labController.text.trim(),
                              viaId: _selectedViaId!,
                            );

                            final response = await TuSaludApi().updateMedicine(
                              widget.medicine.medicineId,
                              request,
                            );

                            setState(() => _isSaving = false);

                            if (!mounted) return;

                            if (response.isSuccess()) {
                              await medicineProvider.loadMedicines();

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "✅ Medicamento actualizado correctamente",
                                  ),
                                ),
                              );

                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "❌ Error: ${response.message ?? 'No se pudo actualizar'}",
                                  ),
                                ),
                              );
                            }
                          }
                        },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
