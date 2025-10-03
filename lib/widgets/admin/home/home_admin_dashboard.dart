import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/admin/beds_admin_provider.dart';
import 'package:tusalud/providers/admin/rooms_admin_provider.dart';
import '../../../generated/l10.dart';
import '../../../style/app_style.dart';

class HomeAdminDashBoard extends StatelessWidget {
  const HomeAdminDashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final bedProvider = Provider.of<BedsAdminProvider>(context, listen: false);
    final roomsProvider = Provider.of<RoomsAdminProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bedId = bedProvider.currentRoomId;
      if (bedId != null) {
        bedProvider.loadBedsByRoom(bedId);
        roomsProvider.loadRooms();
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 🔹 Encabezado tipo tarjeta
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: AppStyle.primary.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppStyle.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: const Icon(
                  Icons.dashboard_rounded,
                  size: 36,
                  color: AppStyle.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  S.of(context).welcomeMessage,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // 🔹 Cards de habitaciones y camas
        Consumer<RoomsAdminProvider>(
          builder: (context, roomsProvider, _) {
            final roomCount = roomsProvider.rooms.length;
            return Row(
              children: [
                Expanded(
                  child: HomeAdminCard(
                    data: roomCount.toString(),
                    icon: Icons.house_rounded,
                    color: AppStyle.primary,
                    title: S.of(context).registredRooms,
                    subtitle: S.of(context).totalRoomsInHospital,
                  ),
                ),
                const SizedBox(width: 16),
                Consumer<BedsAdminProvider>(
                  builder: (context, bedProvider, _) {
                    final bedCount = bedProvider.allBeds.length;
                    return Expanded(
                      child: HomeAdminCard(
                        data: bedCount.toString(),
                        icon: Icons.bed_rounded,
                        color: AppStyle.primary,
                        title: S.of(context).registeredBeds,
                        subtitle: S.of(context).totalBedsInHospital,
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),

        const SizedBox(height: 16),

        // 🔹 Cards de enfermeras y licenciadas (ejemplo, puedes cambiar provider)
        Consumer<RoomsAdminProvider>(
          builder: (context, roomsProvider, _) {
            final roomCount = roomsProvider.rooms.length;
            return Row(
              children: [
                Expanded(
                  child: HomeAdminCard(
                    data: roomCount.toString(),
                    icon: Icons.local_hospital,
                    color: Colors.pinkAccent,
                    title: S.of(context).registeredBachelorNursing,
                    subtitle: S.of(context).totalBachelorNursing,
                  ),
                ),
                const SizedBox(width: 16),
                Consumer<BedsAdminProvider>(
                  builder: (context, bedProvider, _) {
                    final bedCount = bedProvider.allBeds.length;
                    return Expanded(
                      child: HomeAdminCard(
                        data: bedCount.toString(),
                        icon: Icons.medical_services,
                        color: Colors.teal,
                        title: S.of(context).registeredNursing,
                        subtitle: S.of(context).totalNursing,
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class HomeAdminCard extends StatelessWidget {
  const HomeAdminCard({
    super.key,
    required this.data,
    required this.icon,
    required this.color,
    required this.title,
    this.subtitle = '',
  });

  final String data;
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppStyle.primary.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🔹 Ícono arriba
          Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Icon(icon, size: 40, color: color),
          ),

          const SizedBox(height: 12),

          // 🔹 Data destacada
          Text(
            data,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 6),

          // 🔹 Título debajo del número
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),

          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

