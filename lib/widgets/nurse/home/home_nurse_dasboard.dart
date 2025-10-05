import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/admin/beds_admin_provider.dart';
import 'package:tusalud/providers/admin/rooms_admin_provider.dart';
import 'package:tusalud/style/app_style.dart';

class HomeNurseDashBoard extends StatefulWidget {
  const HomeNurseDashBoard({super.key});

  @override
  State<HomeNurseDashBoard> createState() => _HomeNurseDashBoardState();
}

class _HomeNurseDashBoardState extends State<HomeNurseDashBoard> {
  int? selectedRoomId;

  @override
  void initState() {
    super.initState();
    // cargar datos al inicio
    Future.microtask(() {
      Provider.of<BedsAdminProvider>(context, listen: false).loadAllBeds();
      Provider.of<RoomsAdminProvider>(context, listen: false).loadRooms();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<BedsAdminProvider, RoomsAdminProvider>(
      builder: (context, bedsProvider, roomsProvider, child) {
        final totalBeds = bedsProvider.allBeds.length;
        final occupiedBeds =
            bedsProvider.allBeds.where((b) => b.bedStatus == 1).length;
        final freeBeds = totalBeds - occupiedBeds;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Encabezado de bienvenida
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
                      Icons.local_hospital_rounded,
                      size: 36,
                      color: AppStyle.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      "Bienvenida al Panel de Enfermería",
                      style: TextStyle(
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

            // 📊 Resumen general de camas
            Row(
              children: [
                Expanded(
                  child: _buildStatCard("Total de camas", totalBeds.toString(),
                      AppStyle.primary),
                ),
                Expanded(
                  child: _buildStatCard(
                      "Ocupadas", occupiedBeds.toString(), Colors.red),
                ),
                Expanded(
                  child: _buildStatCard(
                      "Libres", freeBeds.toString(), Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 🏥 Selector de sala
            Text("Selecciona una sala:", style: AppStyle.subtitle),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: selectedRoomId,
              hint: const Text("Elegir sala"),
              items: roomsProvider.rooms.map((room) {
                return DropdownMenuItem<int>(
                  value: room.roomId,
                  child: Text(room.roomName ?? ''),
                );
              }).toList(),
              onChanged: (roomId) {
                setState(() => selectedRoomId = roomId);
                if (roomId != null) {
                  bedsProvider.loadBedsByRoom(roomId);
                }
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),

            // 🛏️ Lista de camas de la sala
            if (selectedRoomId != null)
              bedsProvider.isLoading == true
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Camas en la sala:", style: AppStyle.subtitle),
                        const SizedBox(height: 10),
                        ...bedsProvider.bedsByRoom.map(
                          (bed) => Card(
                            child: ListTile(
                              title: Text(bed.bedName ?? 'Sin nombre'),
                              trailing: Icon(
                                bed.bedStatus == 1
                                    ? Icons.bed
                                    : Icons.bed_outlined,
                                color: bed.bedStatus == 1
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
