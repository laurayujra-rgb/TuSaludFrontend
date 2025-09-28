import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/api/response/app/ts_room_response.dart';
import 'package:tusalud/providers/admin/rooms_admin_provider.dart';
import 'package:tusalud/style/app_style.dart';

class EditRoomCard extends StatefulWidget {
  final TsRoomResponse room;

  const EditRoomCard({super.key, required this.room});

  @override
  State<EditRoomCard> createState() => _EditRoomCardState();
}

class _EditRoomCardState extends State<EditRoomCard> {
  final TextEditingController _controller = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _controller.text = ""; // El campo empieza vacío
  }

  Future<void> _updateRoom() async {
    final newName = _controller.text.trim();
    if (newName.isEmpty) {
      await _showAlert("Por favor ingresa el nuevo nombre de la sala");
      return;
    }

    setState(() => _isSubmitting = true);
    await Provider.of<RoomsAdminProvider>(context, listen: false)
        .updateRoom(widget.room.roomId, newName);
    setState(() => _isSubmitting = false);

    if (mounted) Navigator.pop(context);
  }

  Future<void> _showAlert(String message) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Aviso",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppStyle.primary,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              "Aceptar",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppStyle.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppStyle.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nombre actual
          Text(
            "Nombre actual:",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.room.roomName ?? "Sin nombre",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppStyle.primary,
            ),
          ),
          const SizedBox(height: 24),

          // Nuevo nombre
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: "Nuevo nombre de la sala",
              prefixIcon: const Icon(Icons.meeting_room),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Botones
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.red),
                  label: const Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.red),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isSubmitting ? null : _updateRoom,
                  icon: const Icon(Icons.check_circle, color: Colors.green),
                  label: Text(
                    _isSubmitting ? "Actualizando..." : "Actualizar",
                    style: const TextStyle(color: Colors.green),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.green),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
