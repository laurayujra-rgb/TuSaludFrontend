import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/api/request/auth/ts_register_user_admin_request.dart';
import 'package:tusalud/providers/admin/register_user_admin_provider.dart';
import 'package:tusalud/views/admin/peoples/nurses/nurses_admin_view.dart';

class AddNurseAdminCard extends StatefulWidget {
  const AddNurseAdminCard({super.key});

  @override
  State<AddNurseAdminCard> createState() => _AddNurseAdminCardState();
}

class _AddNurseAdminCardState extends State<AddNurseAdminCard> {
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final _nameController = TextEditingController();
  final _fatherSurnameController = TextEditingController();
  final _motherSurnameController = TextEditingController();
  final _dniController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedGenderId; // 👈 ahora seleccionable
  final int roleId = 2; // 👩‍⚕️ Enfermera

  int _calculateAge(DateTime birth) {
    final today = DateTime.now();
    int age = today.year - birth.year;
    if (today.month < birth.month ||
        (today.month == birth.month && today.day < birth.day)) {
      age--;
    }
    return age;
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      helpText: "Selecciona la fecha de nacimiento",
      locale: const Locale("es", "ES"),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _birthdateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        _ageController.text = _calculateAge(picked).toString();
      });
    }
  }

  InputDecoration _inputStyle(String label, {IconData? icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegisterUserAdminProvider>(context);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                "Registrar Enfermera",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _nameController,
                decoration: _inputStyle("Nombre", icon: Icons.person),
                validator: (value) =>
                    value == null || value.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _fatherSurnameController,
                decoration:
                    _inputStyle("Apellido Paterno", icon: Icons.badge),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _motherSurnameController,
                decoration:
                    _inputStyle("Apellido Materno", icon: Icons.badge_outlined),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _dniController,
                decoration: _inputStyle("DNI", icon: Icons.credit_card),
              ),
              const SizedBox(height: 12),

              // Fecha de nacimiento (con DatePicker)
              TextFormField(
                controller: _birthdateController,
                readOnly: true,
                decoration: _inputStyle("Fecha de nacimiento",
                    icon: Icons.calendar_today),
                onTap: () => _pickDate(context),
                validator: (value) =>
                    value == null || value.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 12),

              // Edad (calculada automáticamente)
              TextFormField(
                controller: _ageController,
                readOnly: true,
                decoration: _inputStyle("Edad", icon: Icons.cake),
              ),
              const SizedBox(height: 12),

              // Género (dropdown)
              DropdownButtonFormField<String>(
                value: _selectedGenderId,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.wc, color: Colors.blueAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.blue.withOpacity(0.05),
                ),
                hint: const Text("Seleccione género"),
                items: const [
                  DropdownMenuItem(value: "1", child: Text("Masculino")),
                  DropdownMenuItem(value: "2", child: Text("Femenino")),
                ],
                onChanged: (v) => setState(() => _selectedGenderId = v),
                validator: (v) => v == null ? "Seleccione género" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _emailController,
                decoration: _inputStyle("Correo", icon: Icons.email),
                validator: (value) =>
                    value == null || value.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: _inputStyle("Contraseña", icon: Icons.lock),
                validator: (value) => value == null || value.length < 6
                    ? "Mínimo 6 caracteres"
                    : null,
              ),
              const SizedBox(height: 20),

              provider.isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate() &&
                              _selectedDate != null) {
                            final request = TsRegisterUserAdminRequest(
                              person: TsPersonPart(
                                personName: _nameController.text.trim(),
                                personFatherSurname:
                                    _fatherSurnameController.text.trim(),
                                personMotherSurname:
                                    _motherSurnameController.text.trim(),
                                personDni: _dniController.text.trim(),
                                personBirthdate:
                                    _birthdateController.text.trim(),
                                personAge: int.parse(_ageController.text),
                                genderId: int.parse(_selectedGenderId!),
                                roleId: roleId,
                              ),
                              account: TsAccountPart(
                                accountEmail: _emailController.text.trim(),
                                accountPassword:
                                    _passwordController.text.trim(),
                              ),
                            );

                            final result =
                                await provider.registerUser(request);

                            if (context.mounted) {
                              if (result.data != null) {
                                // ✅ Éxito → diálogo
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    title: Row(
                                      children: const [
                                        Icon(Icons.check_circle,
                                            color: Colors.green, size: 28),
                                        SizedBox(width: 8),
                                        Text("Registro Exitoso"),
                                      ],
                                    ),
                                    content: const Text(
                                      "La enfermera ha sido registrada correctamente.",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          Future.microtask(() {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    const NursesAdminView(),
                                              ),
                                            );
                                          });
                                        },
                                        child: const Text(
                                          "Aceptar",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blueAccent),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                // ❌ Error → diálogo
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    title: Row(
                                      children: const [
                                        Icon(Icons.error,
                                            color: Colors.red, size: 28),
                                        SizedBox(width: 8),
                                        Text("Error"),
                                      ],
                                    ),
                                    content: Text(
                                      result.message ??
                                          "No se pudo registrar la enfermera.",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context),
                                        child: const Text("Cerrar"),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }
                          }
                        },
                        icon: const Icon(Icons.save),
                        label: const Text(
                          "Registrar Enfermera",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
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
