import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/api/request/app/ts_medication_kardex_request.dart';
import 'package:tusalud/providers/admin/medicine_nurse_provider.dart';
import 'package:tusalud/providers/nursing%20Lic/medication_kardex_nursing_lic_provider.dart';
import 'package:tusalud/style/app_style.dart';

class AddMedicationKardexCard extends StatefulWidget {
  final int kardexId;

  const AddMedicationKardexCard({super.key, required this.kardexId});

  @override
  State<AddMedicationKardexCard> createState() => _AddMedicationKardexCardState();
}

class _AddMedicationKardexCardState extends State<AddMedicationKardexCard> {
  final _formKey = GlobalKey<FormState>();
  final _doseController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _routeNoteController = TextEditingController();
  final _notesController = TextEditingController();

  int? _selectedMedicineId;

  @override
  Widget build(BuildContext context) {
    final medicineProvider = Provider.of<MedicineNurseProvider>(context);
    final medicationProvider = Provider.of<MedicationKardexNursingLicProvider>(context, listen: false);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Registrar nuevo medicamento",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppStyle.primary,
                ),
              ),
              const SizedBox(height: 20),

              // 🔹 Selector de medicamento (desde BD)
              DropdownButtonFormField<int>(
                value: _selectedMedicineId,
                decoration: InputDecoration(
                  labelText: "Seleccione el medicamento",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: medicineProvider.medicines
                    .map((med) => DropdownMenuItem<int>(
                          value: med.medicineId,
                          child: Text(med.medicineName ?? 'Sin nombre'),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMedicineId = value;
                  });
                },
                validator: (value) =>
                    value == null ? "Seleccione un medicamento" : null,
              ),
              const SizedBox(height: 16),

              // 🔹 Dosis
              TextFormField(
                controller: _doseController,
                decoration: const InputDecoration(
                  labelText: "Dosis (ej: 500 mg)",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Campo obligatorio" : null,
              ),
              const SizedBox(height: 16),

              // 🔹 Frecuencia
              TextFormField(
                controller: _frequencyController,
                decoration: const InputDecoration(
                  labelText: "Frecuencia (ej: Cada 8 horas)",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Campo obligatorio" : null,
              ),
              const SizedBox(height: 16),

              // 🔹 Vía
              TextFormField(
                controller: _routeNoteController,
                decoration: const InputDecoration(
                  labelText: "Vía de administración (ej: Vía oral)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // 🔹 Notas
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: "Notas adicionales",
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),

              // 🔹 Botón guardar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text(
                    "Guardar Medicamento",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyle.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final request = TsMedicationKardexRequest(
                        kardexId: widget.kardexId,
                        medicineId: _selectedMedicineId!,
                        dose: _doseController.text,
                        frequency: _frequencyController.text,
                        routeNote: _routeNoteController.text,
                        notes: _notesController.text,
                      );

                      final success = await medicationProvider.addMedication(request);
                      if (success && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Medicamento agregado correctamente"),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context, true);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Error: ${medicationProvider.errorMessage ?? 'No se pudo guardar'}"),
                            backgroundColor: Colors.redAccent,
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
