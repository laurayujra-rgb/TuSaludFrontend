import 'package:flutter/material.dart';
import 'package:tusalud/api/response/app/ts_room_response.dart';
import 'package:tusalud/style/app_style.dart';

class BedRoomCard extends StatelessWidget {
  final TsRoomResponse room;
  final bool isSelected;
  final VoidCallback? onTap;

  const BedRoomCard({
    super.key,
    required this.room,
    this.isSelected = false, // 👈 valor por defecto
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppStyle.primary.withOpacity(0.15) // 👈 resalta si está seleccionada
                : AppStyle.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppStyle.primary : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                spreadRadius: 1,
                offset: const Offset(2, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppStyle.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.meeting_room,
                  size: 28,
                  color: AppStyle.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  room.roomName ?? "Sala sin nombre",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: isSelected ? AppStyle.primary : Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
