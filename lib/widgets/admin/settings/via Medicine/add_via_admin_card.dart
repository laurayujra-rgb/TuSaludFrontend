import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/api/request/app/ts_via_request.dart';
import 'package:tusalud/api/tu_salud_api.dart';
import 'package:tusalud/providers/admin/via_admin_provider.dart';
import 'package:tusalud/style/app_style.dart';

class AddViaAdminCard extends StatefulWidget {
  const AddViaAdminCard({super.key});

  @override
  State<AddViaAdminCard> createState() => _AddViaAdminCardState();
}

class _AddViaAdminCardState extends State<AddViaAdminCard> {
  final _formKey = GlobalKey<FormState>();
  final _viaNameController = TextEditingController();

  bool _isSaving = false;

  Future<void> _saveVia() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final request = TsViaRequest(viaName: _viaNameController.text.trim());
    final response = await TuSaludApi().createVia(request);

    setState(() => _isSaving = false);

    if (response.isSuccess()) {
      if (mounted) {
        Provider.of<ViaAdminProvider>(context, listen: false).loadVias();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Vía creada correctamente")),
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
              // 🔹 Encabezado centrado
              Column(
                children: const [
                  Icon(Icons.local_pharmacy,
                      size: 48, color: AppStyle.primary),
                  SizedBox(height: 12),
                  Text(
                    "Nueva Vía de Administración",
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

              // 🔹 Input minimalista
              TextFormField(
                controller: _viaNameController,
                decoration: const InputDecoration(
                  labelText: "Nombre de la vía",
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

              // 🔹 Botón moderno
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveVia,
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
