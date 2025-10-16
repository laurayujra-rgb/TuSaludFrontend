import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/api/tu_salud_api.dart';
import 'package:tusalud/providers/app/profile_provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/widgets/app/custom_app_bar.dart';
import 'dart:convert';

class EditProfileNurseView extends StatefulWidget {
  static const String routerName = 'editProfileNurse';
  static const String routerPath = '/edit_profile_nurse';

  const EditProfileNurseView({super.key});

  @override
  State<EditProfileNurseView> createState() => _EditProfileNurseViewState();
}

class _EditProfileNurseViewState extends State<EditProfileNurseView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _fatherCtrl;
  late TextEditingController _motherCtrl;
  late TextEditingController _birthdateCtrl;
  late TextEditingController _dniCtrl;
  int? _genderId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _fatherCtrl = TextEditingController();
    _motherCtrl = TextEditingController();
    _birthdateCtrl = TextEditingController();
    _dniCtrl = TextEditingController();

    // Cargar datos actuales del usuario
    Future.microtask(() async {
      final provider = Provider.of<ProfileProvider>(context, listen: false);
      await provider.loadCurrentUserData();
      final user = provider.currentUser;

      if (user != null) {
        setState(() {
          _nameCtrl.text = user.personName ?? '';
          _fatherCtrl.text = user.personFahterSurname ?? '';
          _motherCtrl.text = user.personMotherSurname ?? '';
          _birthdateCtrl.text = user.personBirthdate ?? '';
          _dniCtrl.text = user.personDni ?? '';
          _genderId = user.gender.genderId;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _fatherCtrl.dispose();
    _motherCtrl.dispose();
    _birthdateCtrl.dispose();
    _dniCtrl.dispose();
    super.dispose();
  }

  /// ✅ Guardar cambios con recálculo automático de edad
  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final provider = Provider.of<ProfileProvider>(context, listen: false);
    final user = provider.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo obtener el usuario actual')),
      );
      setState(() => _saving = false);
      return;
    }

    // 🔹 Función para calcular edad
    int calculateAge(DateTime birthDate) {
      final today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }
      return age;
    }

    // 🔹 Calcular edad desde la fecha actual del campo
    int personAge = 0;
    try {
      personAge = calculateAge(DateTime.parse(_birthdateCtrl.text));
    } catch (_) {
      personAge = user.personAge ?? 0; // fallback
    }

    final body = {
      "personName": _nameCtrl.text.trim(),
      "personFatherSurname": _fatherCtrl.text.trim(),
      "personMotherSurname": _motherCtrl.text.trim(),
      "personDni": _dniCtrl.text.trim(),
      "personBirthdate": _birthdateCtrl.text.trim(),
      "personAge": personAge, // ✅ edad calculada automáticamente
      "personStatus": 1,
      "gender": {"genderId": _genderId},
      "role": {"roleId": user.role.roleId}
    };

    try {
      final api = TuSaludApi();
      final response = await api.updatePerson(user.personId, body);

      setState(() => _saving = false);

      if (response.isSuccess()) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  response.message ?? 'Perfil actualizado correctamente'),
              backgroundColor: Colors.green,
            ),
          );
          await provider.loadCurrentUserData();
          Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ??
                'Error al actualizar el perfil (${response.status})'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(_birthdateCtrl.text) ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('es', 'ES'),
    );
    if (picked != null) {
      _birthdateCtrl.text = picked.toIso8601String().split('T').first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);
    if (provider.isLoading && provider.currentUser == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppStyle.backgroundModern,
      appBar: CustomAppBar(
        text: 'Editar perfil',
        centerTitle: true,
        backgroundColor: AppStyle.backgroundModern,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              _buildField(_nameCtrl, 'Nombre', Icons.person),
              _buildField(
                  _fatherCtrl, 'Apellido paterno', Icons.person_outline),
              _buildField(
                  _motherCtrl, 'Apellido materno', Icons.person_outline),
              _buildField(_dniCtrl, 'DNI', Icons.credit_card, isNumber: true),
              _buildDateField(),
              _buildGenderSelector(),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppStyle.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _saving ? null : _saveChanges,
                icon: const Icon(Icons.save),
                label: const Text(
                  'Guardar cambios',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label,
      IconData icon,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (v) =>
            (v == null || v.trim().isEmpty) ? 'Campo requerido' : null,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppStyle.primary),
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: _birthdateCtrl,
        readOnly: true,
        onTap: _selectDate,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.cake, color: AppStyle.primary),
          labelText: 'Fecha de nacimiento',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<int>(
        value: _genderId,
        onChanged: (v) => setState(() => _genderId = v),
        items: const [
          DropdownMenuItem(value: 1, child: Text('Masculino')),
          DropdownMenuItem(value: 2, child: Text('Femenino')),
        ],
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.transgender, color: AppStyle.primary),
          labelText: 'Género',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
        validator: (v) => v == null ? 'Seleccione un género' : null,
      ),
    );
  }
}
