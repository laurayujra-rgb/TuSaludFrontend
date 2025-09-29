import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/auth/registe_user_provider.dart';
import 'package:tusalud/widgets/app/custom_field.dart';
import 'package:tusalud/widgets/app/custom_button.dart';

class AddPatientCard extends StatefulWidget {
  const AddPatientCard({super.key});

  @override
  State<AddPatientCard> createState() => _AddPatientCardState();
}

class _AddPatientCardState extends State<AddPatientCard> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _fatherSurnameController = TextEditingController();
  final _motherSurnameController = TextEditingController();
  final _dniController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _ageController = TextEditingController();

  String? _selectedGenderId;
  final int _roleId = 4; // Paciente = rolId = 4

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthdateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<RegisterUserProvider>(context, listen: false);

    await provider.registerUser(
      _nameController.text,
      _fatherSurnameController.text,
      _motherSurnameController.text,
      _dniController.text,
      _birthdateController.text,
      int.tryParse(_ageController.text) ?? 0,
      int.parse(_selectedGenderId!),
      _roleId,
    );

    if (provider.errorMessage == null) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Paciente registrado con éxito")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegisterUserProvider>(context);

    return Card(
      elevation: 6,
      color: Colors.white,
      shadowColor: Colors.teal.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                "Registrar Paciente",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[700],
                ),
              ),
              const SizedBox(height: 24),
              CustomField(
                controller: _nameController,
                hintText: "Nombre",
                prefixIcon: Icon(Icons.person, color: Colors.teal[600]),
                validator: (v) => v == null || v.isEmpty ? "Ingrese nombre" : null,
              ),
              const SizedBox(height: 16),
              CustomField(
                controller: _fatherSurnameController,
                hintText: "Apellido Paterno",
                prefixIcon: Icon(Icons.badge, color: Colors.teal[600]),
                validator: (v) => v == null || v.isEmpty ? "Ingrese apellido paterno" : null,
              ),
              const SizedBox(height: 16),
              CustomField(
                controller: _motherSurnameController,
                hintText: "Apellido Materno",
                prefixIcon: Icon(Icons.badge_outlined, color: Colors.teal[600]),
              ),
              const SizedBox(height: 16),
              CustomField(
                controller: _dniController,
                hintText: "DNI",
                keyboardType: TextInputType.number,
                prefixIcon: Icon(Icons.credit_card, color: Colors.teal[600]),
                validator: (v) => v == null || v.isEmpty ? "Ingrese DNI" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _birthdateController,
                decoration: InputDecoration(
                  hintText: "Fecha de Nacimiento",
                  prefixIcon: Icon(Icons.calendar_today, color: Colors.teal[600]),
                  filled: true,
                  fillColor: Colors.teal.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (v) =>
                    v == null || v.isEmpty ? "Seleccione fecha" : null,
              ),
              const SizedBox(height: 16),
              CustomField(
                controller: _ageController,
                hintText: "Edad",
                keyboardType: TextInputType.number,
                prefixIcon: Icon(Icons.cake, color: Colors.teal[600]),
                validator: (v) =>
                    v == null || v.isEmpty ? "Ingrese edad" : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedGenderId,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.wc, color: Colors.teal[600]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.teal.withOpacity(0.05),
                ),
                hint: const Text("Seleccione género"),
                items: const [
                  DropdownMenuItem(value: "1", child: Text("Masculino")),
                  DropdownMenuItem(value: "2", child: Text("Femenino")),
                ],
                onChanged: (v) => setState(() => _selectedGenderId = v),
                validator: (v) => v == null ? "Seleccione género" : null,
              ),
              const SizedBox(height: 28),
              provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButton(
                      text: "Registrar Paciente",
                      onPressed: _submitForm,
                      backgroundColor: Colors.teal[600]!,
                      color: Colors.white,
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
    super.dispose();
  }
}
