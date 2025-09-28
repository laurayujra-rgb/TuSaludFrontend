import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/admin/rooms_admin_provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/views/admin/hospital/rooms/add_room_admin_vew.dart';
import 'package:tusalud/views/admin/hospital/rooms/edit_room_admin_card.dart';
import 'package:tusalud/widgets/admin/rooms/room_admin_card.dart';

class RoomsAdminView extends StatefulWidget {
  static const String routerName = 'rooms_admin';
  static const String routerPath = '/rooms_admin';

  const RoomsAdminView({super.key});

  @override
  State<RoomsAdminView> createState() => _RoomsAdminViewState();
}

class _RoomsAdminViewState extends State<RoomsAdminView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<RoomsAdminProvider>(context, listen: false).loadRooms());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.ligthGrey,
      body: Column(
        children: [
          // HEADER con flecha atrás
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 8),
            child: Row(
              children: [
                // Flecha atrás
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppStyle.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          spreadRadius: 2,
                          offset: const Offset(2, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                      color: AppStyle.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Card título
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
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
                          padding: const EdgeInsets.all(12),
                          child: const Icon(
                            Icons.meeting_room,
                            size: 36,
                            color: AppStyle.primary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Administración de Salas",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Gestiona las salas disponibles en el hospital",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Botón agregar
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddRoomAdminView(),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add_circle,
                      size: 30,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // LISTADO DE SALAS
          Expanded(
            child: Consumer<RoomsAdminProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.rooms.isEmpty) {
                  return const Center(child: Text("No hay salas registradas"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: provider.rooms.length,
                  itemBuilder: (context, index) {
                    final room = provider.rooms[index];
                    return RoomAdminCard(
                      room: room,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Seleccionaste ${room.roomName}"),
                          ),
                        );
                      },
                      onEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditRoomAdminView(room: room),
                          ),
                        );
                      },
                      onDelete: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text("Confirmar eliminación"),
                            content: Text(
                              "¿Deseas eliminar la sala '${room.roomName}'?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text("Cancelar"),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text("Eliminar"),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await Provider.of<RoomsAdminProvider>(
                            context,
                            listen: false,
                          ).deleteRoom(room.roomId);
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
