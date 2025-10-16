import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/api/request/app/ts_medication_kardex_request.dart';
import 'package:tusalud/api/response/app/ts_kardex_medicine_response.dart';
import 'package:tusalud/providers/nursing%20Lic/medication_kardex_nursing_lic_provider.dart';
import 'package:tusalud/style/app_style.dart';

class EditMedicationKardexView extends StatefulWidget {
  static const String routerName = 'editMedicationKardex';
  static const String routerPath = '/edit_medication_kardex';

  final TsMedicationKardexResponse medication;

  const EditMedicationKardexView({super.key, required this.medication});

  @override
  State<EditMedicationKardexView> createState() =>
      _EditMedicationKardexViewState();
}

class _EditMedicationKardexViewState extends State<EditMedicationKardexView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _doseController;
  late TextEditingController _frequencyController;
  late TextEditingController _routeNoteController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _doseController = TextEditingController(text: widget.medication.dose);
    _frequencyController = TextEditingController(text: widget.medication.frequency);
    _routeNoteController = TextEditingController(text: widget.medication.routeNote);
    _notesController = TextEditingController(text: widget.medication.notes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.ligthGrey,
      appBar: AppBar(
        backgroundColor: AppStyle.primary,
        title: const Text("Editar Medicación"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _doseController,
                decoration: const InputDecoration(
                  labelText: "Dosis",
                  prefixIcon: Icon(Icons.medication_outlined),
                ),
                validator: (v) => v!.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _frequencyController,
                decoration: const InputDecoration(
                  labelText: "Frecuencia",
                  prefixIcon: Icon(Icons.schedule),
                ),
                validator: (v) => v!.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _routeNoteController,
                decoration: const InputDecoration(
                  labelText: "Vía de administración",
                  prefixIcon: Icon(Icons.local_hospital),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: "Notas",
                  prefixIcon: Icon(Icons.note_alt_outlined),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Guardar Cambios"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyle.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final request = TsMedicationKardexRequest(
                    kardexId: widget.medication.kardexId,
                    medicineId: widget.medication.medicineId,
                    dose: _doseController.text,
                    frequency: _frequencyController.text,
                    routeNote: _routeNoteController.text,
                    notes: _notesController.text,
                  );

                  final success = await Provider.of<MedicationKardexNursingLicProvider>(
                    context,
                    listen: false,
                  ).updateMedication(widget.medication.id, request);

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Medicamento actualizado con éxito")),
                    );
                    Navigator.pop(context, true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Error al actualizar medicación")),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
