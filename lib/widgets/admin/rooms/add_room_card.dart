import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/admin/rooms_admin_provider.dart';
import 'package:tusalud/style/app_style.dart';

class AddRoomAdminCard extends StatefulWidget {
  const AddRoomAdminCard({super.key});

  @override
  State<AddRoomAdminCard> createState() => _AddRoomAdminCardState();
}

class _AddRoomAdminCardState extends State<AddRoomAdminCard> {
  final TextEditingController _controller = TextEditingController();
  bool _isSubmitting = false;

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

  Future<void> _saveRoom() async {
    final name = _controller.text.trim();
    if (name.isEmpty) {
      await _showAlert("Por favor ingresa un nombre de sala");
      return;
    }

    setState(() => _isSubmitting = true);
    await Provider.of<RoomsAdminProvider>(context, listen: false).addRoom(name);
    setState(() => _isSubmitting = false);

    if (mounted) Navigator.pop(context); // volver atrás
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: "Nombre de la sala",
              prefixIcon: const Icon(Icons.meeting_room),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Botones en fila
          Row(
            children: [
              // Botón Cancelar
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

              // Botón Guardar
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _isSubmitting ? null : _saveRoom,
                  icon: const Icon(Icons.check_circle, color: Colors.green),
                  label: Text(
                    _isSubmitting ? "Guardando..." : "Guardar Sala",
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
