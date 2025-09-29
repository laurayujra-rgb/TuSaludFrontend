import 'package:flutter/material.dart';
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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppStyle.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: const Icon(Icons.restaurant_menu,
                  color: AppStyle.primary, size: 30),
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
            if (onEdit != null)
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.orange),
                onPressed: onEdit,
              ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }
}
