import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/api/request/auth/ts_register_user_admin_request.dart';
import 'package:tusalud/providers/admin/gender_provider.dart';
import 'package:tusalud/providers/admin/register_user_admin_provider.dart';

class AddSupervisorAdminCard extends StatefulWidget {
  const AddSupervisorAdminCard({super.key});

  @override
  State<AddSupervisorAdminCard> createState() => _AddSupervisorAdminCardState();
}

class _AddSupervisorAdminCardState extends State<AddSupervisorAdminCard> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _fatherSurnameController = TextEditingController();
  final _motherSurnameController = TextEditingController();
  final _dniController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedGenderId;
  final int roleId = 3; // 👩‍💼 Supervisora (según tu pedido)

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
    final provider = context.watch<RegisterUserAdminProvider>();
    final genderProvider = context.watch<GenderAdminProvider>();

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
                "Registrar Supervisora",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _nameController,
                decoration: _inputStyle("Nombre", icon: Icons.person),
                validator: (value) => value == null || value.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _fatherSurnameController,
                decoration: _inputStyle("Apellido Paterno", icon: Icons.badge),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _motherSurnameController,
                decoration: _inputStyle("Apellido Materno", icon: Icons.badge_outlined),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _dniController,
                decoration: _inputStyle("DNI", icon: Icons.credit_card),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _birthdateController,
                readOnly: true,
                decoration: _inputStyle("Fecha de nacimiento", icon: Icons.calendar_today),
                onTap: () => _pickDate(context),
                validator: (value) => value == null || value.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _ageController,
                readOnly: true,
                decoration: _inputStyle("Edad", icon: Icons.cake),
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: _selectedGenderId,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.wc, color: Colors.deepPurple),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.deepPurple.withOpacity(0.05),
                ),
                hint: const Text("Seleccione género"),
                items: genderProvider.genders.map((g) {
                  return DropdownMenuItem(
                    value: g.genderId.toString(),
                    child: Text(g.genderName ?? ""),
                  );
                }).toList(),
                onChanged: (v) => setState(() => _selectedGenderId = v),
                validator: (v) => v == null ? "Seleccione género" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _emailController,
                decoration: _inputStyle("Correo", icon: Icons.email),
                validator: (value) => value == null || value.isEmpty ? "Campo requerido" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: _inputStyle("Contraseña", icon: Icons.lock),
                validator: (value) => value == null || value.length < 6 ? "Mínimo 6 caracteres" : null,
              ),
              const SizedBox(height: 20),

              provider.isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate() && _selectedDate != null) {
                            final request = TsRegisterUserAdminRequest(
                              person: TsPersonPart(
                                personName: _nameController.text.trim(),
                                personFatherSurname: _fatherSurnameController.text.trim(),
                                personMotherSurname: _motherSurnameController.text.trim(),
                                personDni: _dniController.text.trim(),
                                personBirthdate: _birthdateController.text.trim(),
                                personAge: int.parse(_ageController.text),
                                genderId: int.parse(_selectedGenderId!),
                                roleId: roleId, // 👈 SUPERVISORA = 3
                              ),
                              account: TsAccountPart(
                                accountEmail: _emailController.text.trim(),
                                accountPassword: _passwordController.text.trim(),
                              ),
                            );

                            final result = await context.read<RegisterUserAdminProvider>().registerUser(request);
                            if (!mounted) return;

                            if (result.data != null) {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => AlertDialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  title: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.check_circle, color: Colors.green, size: 50),
                                      SizedBox(height: 12),
                                      Text("Registro Exitoso",
                                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  content: const Text("La supervisora ha sido registrada correctamente.",
                                      textAlign: TextAlign.center),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.deepPurple,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context, rootNavigator: true).pop(); // cierra diálogo
                                        Navigator.of(context).pop(true); // vuelve y refresca lista
                                      },
                                      child: const Text("Aceptar"),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  title: Row(
                                    children: const [
                                      Icon(Icons.error, color: Colors.red, size: 28),
                                      SizedBox(width: 8),
                                      Text("Error"),
                                    ],
                                  ),
                                  content: Text(
                                    result.message ?? "No se pudo registrar la supervisora.",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(),
                                      child: const Text("Cerrar"),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.save),
                        label: const Text(
                          "Registrar Supervisora",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _fatherSurnameController.dispose();
    _motherSurnameController.dispose();
    _dniController.dispose();
    _birthdateController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
