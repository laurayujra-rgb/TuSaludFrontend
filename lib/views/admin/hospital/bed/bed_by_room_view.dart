import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/api/response/app/ts_room_response.dart';
import 'package:tusalud/providers/admin/beds_admin_provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/widgets/admin/beds/bed_admin_card.dart';

class BedsByRoomView extends StatefulWidget {
  final TsRoomResponse room;

  const BedsByRoomView({super.key, required this.room});

  @override
  State<BedsByRoomView> createState() => _BedsByRoomViewState();
}

class _BedsByRoomViewState extends State<BedsByRoomView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<BedsAdminProvider>(context, listen: false)
          .loadBedsByRoom(widget.room.roomId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.ligthGrey,
      body: Column(
        children: [
          // HEADER con flecha atrás y título
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 8),
            child: Row(
              children: [
                // Botón atrás
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
                            Icons.bed_rounded,
                            size: 36,
                            color: AppStyle.primary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Camas de ${widget.room.roomName}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "Consulta las camas de esta sala",
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
              ],
            ),
          ),

          // CONTENIDO: listado de camas
          Expanded(
            child: Consumer<BedsAdminProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading == true) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.bedsByRoom.isEmpty) {
                  return const Center(child: Text("No hay camas registradas"));
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
      ),
    );
  }
}
