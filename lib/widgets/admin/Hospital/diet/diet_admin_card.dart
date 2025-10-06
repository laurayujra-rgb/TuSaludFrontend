import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tusalud/api/response/app/ts_diet_response.dart';
import 'package:tusalud/style/app_style.dart';

class DietNurseCard extends StatelessWidget {
  final TsDietResponse diet;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const DietNurseCard({
    super.key,
    required this.diet,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 16, right: 16),
      child: Slidable(
        key: ValueKey(diet.dietId),

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

        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppStyle.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                spreadRadius: 2,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppStyle.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.restaurant_menu,
                    color: AppStyle.primary, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  diet.dietName ?? 'Sin nombre',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
