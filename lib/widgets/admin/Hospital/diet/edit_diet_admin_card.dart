import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/api/request/app/ts_diet_request.dart';
import 'package:tusalud/api/response/app/ts_diet_response.dart';
import 'package:tusalud/providers/admin/diet_admin_provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/api/tu_salud_api.dart';

class EditDietAdminCard extends StatefulWidget {
  final TsDietResponse diet;

  const EditDietAdminCard({super.key, required this.diet});

  @override
  State<EditDietAdminCard> createState() => _EditDietAdminCardState();
}

class _EditDietAdminCardState extends State<EditDietAdminCard> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.diet.dietName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DietAdminProvider>();

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Icon(Icons.restaurant_menu, size: 48, color: AppStyle.primary),
              const SizedBox(height: 12),
              const Text(
                "Editar Dieta",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // Campo nombre
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nombre de la dieta",
                  prefixIcon: Icon(Icons.edit),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Ingrese un nombre válido";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),

              // Botón guardar
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _isSaving = true);

                            final response = await TuSaludApi().updateDiet(
                              widget.diet.dietId!,
                              TsDietRequest(dietName: _nameController.text.trim()),
                            );

                            // 👇 Verificamos si el widget sigue montado
                            if (!mounted) return;

                            setState(() => _isSaving = false);

                            if (response.isSuccess()) {
                              // 🔹 Recargamos lista desde provider
                              await Provider.of<DietAdminProvider>(context, listen: false)
                                  .loadDiets();

                              // 👇 Verificamos otra vez antes de usar context
                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("✅ Dieta actualizada correctamente"),
                                ),
                              );
                              Navigator.pop(context);
                            } else {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "❌ Error: ${response.message ?? 'Error al actualizar'}",
                                  ),
                                ),
                              );
                            }
                          }
                        },
                  child: _isSaving
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text("Guardar"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
