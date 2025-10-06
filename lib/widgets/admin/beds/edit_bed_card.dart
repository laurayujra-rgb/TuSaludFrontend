import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/admin/beds_admin_provider.dart';
import 'package:tusalud/providers/admin/rooms_admin_provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/api/response/app/ts_bed_response.dart';
import 'package:tusalud/api/response/app/ts_room_response.dart';

class EditBedAdminCard extends StatefulWidget {
  final TsBedsResponse bed;

  const EditBedAdminCard({super.key, required this.bed});

  @override
  State<EditBedAdminCard> createState() => _EditBedAdminCardState();
}

class _EditBedAdminCardState extends State<EditBedAdminCard> {
  final _formKey = GlobalKey<FormState>();
  final _bedNameController = TextEditingController();
  TsRoomResponse? _selectedRoom;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _bedNameController.text = widget.bed.bedName ?? '';
    _selectedRoom = widget.bed.room;
    Future.microtask(() =>
        Provider.of<RoomsAdminProvider>(context, listen: false).loadRooms());
  }

  @override
  Widget build(BuildContext context) {
    final roomsProvider = context.watch<RoomsAdminProvider>();
    final bedsProvider = context.watch<BedsAdminProvider>();

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
              const Icon(Icons.bed_rounded, size: 48, color: AppStyle.primary),
              const SizedBox(height: 12),
              const Text(
                "Editar cama",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // Campo nombre
              TextFormField(
                controller: _bedNameController,
                decoration: const InputDecoration(
                  labelText: "Nuevo nombre de la cama",
                  prefixIcon: Icon(Icons.edit),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Ingrese un nombre válido";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Selector de sala
// Selector de sala
DropdownButtonFormField<TsRoomResponse>(
  value: roomsProvider.rooms.firstWhere(
    (r) => r.roomId == _selectedRoom?.roomId,
    orElse: () => roomsProvider.rooms.isNotEmpty
        ? roomsProvider.rooms.first
        : _selectedRoom!,
  ),
  items: roomsProvider.rooms
      .map((room) => DropdownMenuItem(
            value: room,
            child: Text(room.roomName ?? 'Sala sin nombre'),
          ))
      .toList(),
  onChanged: (room) {
    setState(() => _selectedRoom = room);
  },
  decoration: const InputDecoration(
    labelText: "Seleccione una sala",
    prefixIcon: Icon(Icons.meeting_room),
  ),
  validator: (value) =>
      value == null ? "Seleccione una sala" : null,
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

                            await bedsProvider.updateBed(
                              widget.bed.bedId,
                              _bedNameController.text.trim(),
                              _selectedRoom!.roomId,
                            );

                            setState(() => _isSaving = false);

                            if (bedsProvider.errorMessage == null &&
                                context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "✅ Cama actualizada correctamente"),
                                ),
                              );
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "❌ Error: ${bedsProvider.errorMessage}"),
                                ),
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyle.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2)
                      : const Text(
                          "Guardar cambios",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
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
