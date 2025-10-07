import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tusalud/api/response/app/ts_bed_response.dart';
import 'package:tusalud/style/app_style.dart';

class BedAdminCard extends StatelessWidget {
  final TsBedsResponse bed;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const BedAdminCard({
    super.key,
    required this.bed,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOccupied = bed.bedOccupied == true;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Slidable(
        key: ValueKey(bed.bedId),

        // 👉 Deslizar a la izquierda → Editar
        startActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              onPressed: (_) => onEdit?.call(),
              backgroundColor: Colors.blue.shade100,
              foregroundColor: Colors.blue.shade900,
              icon: Icons.edit,
              label: 'Editar',
            ),
          ],
        ),

        // 👉 Deslizar a la derecha → Eliminar
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              onPressed: (_) => onDelete?.call(),
              backgroundColor: Colors.red.shade100,
              foregroundColor: Colors.red.shade900,
              icon: Icons.delete,
              label: 'Eliminar',
            ),
          ],
        ),

        // 👉 Card principal
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isOccupied ? Colors.red.shade50 : Colors.green.shade50,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 6,
                  spreadRadius: 1,
                  offset: const Offset(2, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                // Ícono de cama
                Container(
                  decoration: BoxDecoration(
                    color: AppStyle.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: const Icon(
                    Icons.bed_rounded,
                    size: 32,
                    color: AppStyle.primary,
                  ),
                ),
                const SizedBox(width: 16),

                // Información
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bed.bedName ?? "Cama sin nombre",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Sala: ${bed.room.roomName ?? 'Sin sala'}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // 🔹 Estado de la cama (ocupada / disponible)
                      Row(
                        children: [
                          Icon(
                            isOccupied ? Icons.lock : Icons.lock_open,
                            color:
                                isOccupied ? Colors.redAccent : Colors.green,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            isOccupied ? "Ocupada" : "Disponible",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color:
                                  isOccupied ? Colors.redAccent : Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Flecha al final
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
