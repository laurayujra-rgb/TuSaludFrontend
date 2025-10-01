import 'package:flutter/material.dart';
import 'package:tusalud/api/response/app/ts_via_response.dart';
import 'package:tusalud/style/app_style.dart';

class ViaCard extends StatelessWidget {
  final TsViaResponse via;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ViaCard({
    super.key,
    required this.via,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppStyle.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icono decorativo
          Container(
            decoration: BoxDecoration(
              color: AppStyle.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(10),
            child: const Icon(
              Icons.local_hospital,
              color: AppStyle.primary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),

          // Nombre de la vía
          Expanded(
            child: Text(
              via.viaName ?? 'Sin nombre',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),

          // Acciones
          if (onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit, color: AppStyle.primary),
              onPressed: onEdit,
              tooltip: "Editar vía",
            ),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
              tooltip: "Eliminar vía",
            ),
        ],
      ),
    );
  }
}
