import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/admin/rooms_admin_provider.dart';
import 'package:tusalud/providers/admin/beds_admin_provider.dart';
import 'package:tusalud/widgets/admin/beds/bed_admin_card.dart';
import 'package:tusalud/widgets/admin/beds/bed_room_card.dart';

class BedsTabByRoomView extends StatefulWidget {
  const BedsTabByRoomView({super.key});

  @override
  State<BedsTabByRoomView> createState() => _BedsTabByRoomViewState();
}

class _BedsTabByRoomViewState extends State<BedsTabByRoomView> {
  int? selectedRoomId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<RoomsAdminProvider>(context, listen: false).loadRooms());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Lista de salas
        Expanded(
          flex: 1,
          child: Consumer<RoomsAdminProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (provider.rooms.isEmpty) {
                return const Center(child: Text("No hay salas registradas"));
              }

              return ListView.builder(
                itemCount: provider.rooms.length,
                itemBuilder: (context, index) {
                  final room = provider.rooms[index];
                  return BedRoomCard(
                    room: room,
                    isSelected: selectedRoomId == room.roomId,
                    onTap: () {
                      setState(() => selectedRoomId = room.roomId);
                      Provider.of<BedsAdminProvider>(context, listen: false)
                          .loadBedsByRoom(room.roomId);
                    },
                  );
                },
              );
            },
          ),
        ),

        // Lista de camas de la sala seleccionada
        Expanded(
          flex: 2,
          child: Consumer<BedsAdminProvider>(
            builder: (context, provider, child) {
              if (selectedRoomId == null) {
                return const Center(child: Text("Selecciona una sala"));
              }
              if (provider.isLoading == true) {
                return const Center(child: CircularProgressIndicator());
              }
              if (provider.bedsByRoom.isEmpty) {
                return const Center(child: Text("No hay camas en esta sala"));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: provider.bedsByRoom.length,
                itemBuilder: (context, index) {
                  final bed = provider.bedsByRoom[index];
                  return BedAdminCard(bed: bed);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
