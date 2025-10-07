// lib/widgets/admin/people/patients/add_patients_admin_card.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/api/request/app/ts_request_create_request.dart';
import 'package:tusalud/providers/admin/beds_admin_provider.dart';
import 'package:tusalud/providers/admin/gender_provider.dart';
import 'package:tusalud/providers/admin/register_patient_provider.dart';
import 'package:tusalud/providers/admin/rooms_admin_provider.dart';
import 'package:tusalud/widgets/app/custom_button.dart';
import 'package:tusalud/widgets/app/custom_field.dart';

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
  int? _selectedRoomId;
  int? _selectedBedId; // depende de la sala

  @override
  void initState() {
    super.initState();
    // Gender y Rooms ya se cargan en los providers en AddPatientView
  }

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
        final today = DateTime.now();
        int age = today.year - picked.year;
        if (today.month < picked.month ||
            (today.month == picked.month && today.day < picked.day)) {
          age--;
        }
        _ageController.text = age.toString();
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    // Validaciones adicionales: sala y cama
    if (_selectedRoomId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Seleccione una sala")),
      );
      return;
    }
    if (_selectedBedId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Seleccione una cama")),
      );
      return;
    }

    final regProvider = context.read<RegisterPatientProvider>();

    final req = TsPatientCreateRequest(
      personName: _nameController.text.trim(),
      personFatherSurname: _fatherSurnameController.text.trim(),
      personMotherSurname: _motherSurnameController.text.trim().isEmpty
          ? null
          : _motherSurnameController.text.trim(),
      personDni: _dniController.text.trim(),
      personBirthdate: _birthdateController.text.trim(),
      personAge: int.tryParse(_ageController.text.trim()) ?? 0,
      genderId: int.parse(_selectedGenderId!),
      bedId: _selectedBedId!, // 👈 cama obligatoria
    );

    final resp = await regProvider.registerPatient(req);

    if (resp.isSuccess()) {
      if (mounted) {
        Navigator.of(context).pop(true); // para refrescar lista
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Paciente registrado con éxito")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(regProvider.errorMessage ?? "Error al registrar")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final registerProvider = context.watch<RegisterPatientProvider>();
    final genderProvider = context.watch<GenderAdminProvider>();
    final roomsProvider  = context.watch<RoomsAdminProvider>();
    final bedsProvider   = context.watch<BedsAdminProvider>();

    // Camas: solo libres de la sala seleccionada
    final bedsInRoom = (_selectedRoomId == null)
        ? <dynamic>[]
        : bedsProvider.bedsByRoom.where((b) => b.bedOccupied != true).toList();

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

              // Datos personales
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
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
                validator: (v) => v == null || v.isEmpty ? "Seleccione fecha" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _ageController,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: "Edad",
                  prefixIcon: Icon(Icons.cake, color: Colors.teal[600]),
                  filled: true,
                  fillColor: Colors.teal.withOpacity(0.05),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),

              // Género
              DropdownButtonFormField<String>(
                value: _selectedGenderId,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.wc, color: Colors.teal[600]),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.teal.withOpacity(0.05),
                ),
                hint: const Text("Seleccione género"),
                items: genderProvider.genders.map((g) {
                  return DropdownMenuItem(
                    value: g.genderId.toString(),
                    child: Text(g.genderName ?? "Sin nombre"),
                  );
                }).toList(),
                onChanged: (v) => setState(() => _selectedGenderId = v),
                validator: (v) => v == null ? "Seleccione género" : null,
              ),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 8),

              // Sala
              DropdownButtonFormField<int>(
                value: _selectedRoomId,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.meeting_room, color: Colors.teal[600]),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.teal.withOpacity(0.05),
                ),
                hint: const Text("Seleccione sala"),
                items: roomsProvider.rooms.map((r) {
                  return DropdownMenuItem(
                    value: r.roomId,
                    child: Text(r.roomName ?? "Sin nombre"),
                  );
                }).toList(),
                onChanged: (roomId) async {
                  setState(() {
                    _selectedRoomId = roomId;
                    _selectedBedId = null; // reset cama
                  });
                  if (roomId != null) {
                    await context.read<BedsAdminProvider>().loadBedsByRoom(roomId);
                  }
                },
                validator: (v) => v == null ? "Seleccione sala" : null,
              ),

              const SizedBox(height: 16),

              // Cama (solo libres)
              DropdownButtonFormField<int>(
                value: _selectedBedId,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.bed, color: Colors.teal[600]),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.teal.withOpacity(0.05),
                ),
                hint: const Text("Seleccione cama"),
                items: bedsInRoom.map<DropdownMenuItem<int>>((b) {
                  return DropdownMenuItem(
                    value: b.bedId,
                    child: Text("${b.bedName ?? 'Cama'}  ${b.bedOccupied == true ? '(Ocupada)' : ''}"),
                  );
                }).toList(),
                onChanged: (bedId) => setState(() => _selectedBedId = bedId),
                validator: (v) => v == null ? "Seleccione cama" : null,
              ),

              const SizedBox(height: 28),
              registerProvider.isLoading
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
