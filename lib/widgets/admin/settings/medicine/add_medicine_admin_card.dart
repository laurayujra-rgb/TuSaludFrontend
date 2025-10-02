import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/api/response/app/ts_via_response.dart';
import 'package:tusalud/providers/admin/via_admin_provider.dart';
import 'package:tusalud/style/app_style.dart';

class AddMedicineAdminCard extends StatefulWidget {
  final void Function(String name, String lab, TsViaResponse via) onSubmit;

  const AddMedicineAdminCard({super.key, required this.onSubmit});

  @override
  State<AddMedicineAdminCard> createState() => _AddMedicineAdminCardState();
}

class _AddMedicineAdminCardState extends State<AddMedicineAdminCard> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _labController = TextEditingController();
  TsViaResponse? _selectedVia;

  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final viaProvider = context.watch<ViaAdminProvider>();

    return Card(
      color: AppStyle.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 🔹 Encabezado
              Column(
                children: const [
                  Icon(Icons.medical_services,
                      size: 48, color: AppStyle.primary),
                  SizedBox(height: 12),
                  Text(
                    "Nuevo Medicamento",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // 🔹 Campo nombre
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nombre del medicamento",
                  labelStyle: TextStyle(color: Colors.black54),
                  prefixIcon:
                      Icon(Icons.medication, color: Colors.black45),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26, width: 1),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppStyle.primary, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Ingrese un nombre válido";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // 🔹 Campo laboratorio
              TextFormField(
                controller: _labController,
                decoration: const InputDecoration(
                  labelText: "Laboratorio",
                  labelStyle: TextStyle(color: Colors.black54),
                  prefixIcon: Icon(Icons.science, color: Colors.black45),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26, width: 1),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppStyle.primary, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Ingrese un laboratorio válido";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // 🔹 Dropdown vías
              DropdownButtonFormField<TsViaResponse>(
                value: _selectedVia,
                items: viaProvider.vias
                    .map((via) => DropdownMenuItem(
                          value: via,
                          child: Text(via.viaName ?? ''),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => _selectedVia = val),
                decoration: const InputDecoration(
                  labelText: "Vía de administración",
                  labelStyle: TextStyle(color: Colors.black54),
                  prefixIcon:
                      Icon(Icons.local_hospital, color: Colors.black45),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black26, width: 1),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppStyle.primary, width: 2),
                  ),
                ),
                validator: (v) =>
                    v == null ? "Seleccione una vía de administración" : null,
              ),
              const SizedBox(height: 50),

              // 🔹 Botón Guardar
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate() &&
                              _selectedVia != null) {
                            setState(() => _isSaving = true);
                            widget.onSubmit(
                              _nameController.text.trim(),
                              _labController.text.trim(),
                              _selectedVia!,
                            );
                            setState(() => _isSaving = false);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyle.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 1,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Guardar",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
