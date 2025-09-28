import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/admin/beds_admin_provider.dart';
import 'package:tusalud/providers/admin/rooms_admin_provider.dart';
import '../../generated/l10.dart';
import '../../style/app_style.dart';
class HomeAdminDashBoard extends StatelessWidget {
  const HomeAdminDashBoard({super.key});
  @override
  Widget build(BuildContext context) {
    final bedProvider = Provider.of<BedsAdminProvider>(context, listen: false);
    final roomsProvider = Provider.of<RoomsAdminProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bedId = bedProvider.currentRoomId;
      if(bedId != null){
        bedProvider.loadBedsByRoom(bedId);
        roomsProvider.loadRooms();
      }
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppStyle.white, width: 1),
            borderRadius: BorderRadius.circular(8),
            color: AppStyle.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
            child: Text(
              S.of(context).welcomeMessage,
              style: const TextStyle(
                color: AppStyle.primary,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Consumer<RoomsAdminProvider>(
          builder: (context, roomsProvider, _){
            final roomCount = roomsProvider.rooms.length;
            return Row(
              children: [
                Expanded(
                  child: HomeAdminCard(
                    data: roomCount.toString(),
                    icon: const Icon(Icons.house_rounded,
                    color: AppStyle.primary,
                    size: 40
                    ),
                    title: S.of(context).registredRooms,
                    subtitle: S.of(context).totalRoomsInHospital,
                  ),
                ),
                const SizedBox(width: 16),
                Consumer<BedsAdminProvider>(
                  builder: (context, bedProvider, _){
                    final bedCount = bedProvider.allBeds.length;
                    return Expanded(
                      child: HomeAdminCard(
                        data: bedCount.toString(),
                        icon: const Icon(Icons.bed_rounded,
                        color: AppStyle.primary,
                        size: 40
                        ),
                        title: S.of(context).registeredBeds,
                        subtitle: S.of(context).totalBedsInHospital,
                      ),
                    );
                  }
                )
              ],
            );
          },
        ),
        const SizedBox(height: 16),
// cambair el provider
        Consumer<RoomsAdminProvider>(
          builder: (context, roomsProvider, _){
            final roomCount = roomsProvider.rooms.length;
            return Row(
              children: [
                Expanded(
                  child: HomeAdminCard(
                    data: roomCount.toString(),
                    icon: const Icon(Icons.local_hospital,
                    color: AppStyle.primary,
                    size: 40
                    ),
                    title: S.of(context).registeredBachelorNursing,
                    subtitle: S.of(context).totalBachelorNursing,
                  ),
                ),
                const SizedBox(width: 16),
                Consumer<BedsAdminProvider>(
                  builder: (context, bedProvider, _){
                    final bedCount = bedProvider.allBeds.length;
                    return Expanded(
                      child: HomeAdminCard(
                        data: bedCount.toString(),
                        icon: const Icon(Icons.bed_rounded,
                        color: AppStyle.primary,
                        size: 40
                        ),
                        title: S.of(context).registeredNursing,
                        subtitle: S.of(context).totalNursing,
                      ),
                    );
                  }
                )
              ],
            );
          },
        ),
        /// Agregar para cajas para supervisoras y enfermeras
      ],
    );
  }
}
class HomeAdminCard extends StatelessWidget {
  const HomeAdminCard({
    super.key,
    required this.data,
    required this.icon,
    required this.title,
    this.subtitle = '',
  });

  final String data;
  final Widget icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppStyle.white, width: 1),
        borderRadius: BorderRadius.circular(8),
        color: AppStyle.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    data,
                    style: const TextStyle(
                      color: AppStyle.primary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
