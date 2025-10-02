import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/api/request/app/ts_diet_request.dart';
import 'package:tusalud/api/tu_salud_api.dart';
import 'package:tusalud/providers/admin/diet_admin_provider.dart';
import 'package:tusalud/style/app_style.dart';

class AddDietAdminCard extends StatefulWidget {
  const AddDietAdminCard({super.key});

  @override
  State<AddDietAdminCard> createState() => _AddDietAdminCardState();
}

class _AddDietAdminCardState extends State<AddDietAdminCard> {
  final _formKey = GlobalKey<FormState>();
  final _dietNameController = TextEditingController();

  bool _isSaving = false;

  Future<void> _saveDiet() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final request = TsDietRequest(dietName: _dietNameController.text.trim());
    final response = await TuSaludApi().createDiet(request);

    setState(() => _isSaving = false);

    if (response.isSuccess()) {
      if (mounted) {
        Provider.of<DietAdminProvider>(context, listen: false).loadDiets();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Dieta creada correctamente")),
        );
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error: ${response.message ?? 'No se pudo crear'}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  Icon(Icons.restaurant_menu,
                      size: 48, color: AppStyle.primary),
                  SizedBox(height: 12),
                  Text(
                    "Nueva Dieta",
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

              // 🔹 Campo de texto
              TextFormField(
                controller: _dietNameController,
                decoration: const InputDecoration(
                  labelText: "Nombre de la dieta",
                  labelStyle: TextStyle(color: Colors.black54),
                  prefixIcon: Icon(Icons.edit_note, color: Colors.black45),
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
              const SizedBox(height: 50),

              // 🔹 Botón Guardar
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveDiet,
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
