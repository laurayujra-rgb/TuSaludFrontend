import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/admin/rooms_admin_provider.dart';
import 'package:tusalud/providers/admin/beds_admin_provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/views/admin/hospital/bed/add_beds_admin_view.dart';
import 'package:tusalud/views/admin/hospital/bed/bed_by_room_view.dart';
import 'package:tusalud/widgets/admin/beds/bed_admin_card.dart';
import 'package:tusalud/widgets/admin/beds/bed_room_card.dart';

class BedsAdminView extends StatefulWidget {
  static const String routerName = 'beds_admin';
  static const String routerPath = '/beds_admin';

  const BedsAdminView({super.key});

  @override
  State<BedsAdminView> createState() => _BedsAdminViewState();
}

class _BedsAdminViewState extends State<BedsAdminView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // cargar todas las camas al iniciar
    Future.microtask(() =>
        Provider.of<BedsAdminProvider>(context, listen: false).loadAllBeds());
    // cargar salas
    Future.microtask(() =>
        Provider.of<RoomsAdminProvider>(context, listen: false).loadRooms());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.ligthGrey,
      body: Column(
        children: [
Padding(
  padding: const EdgeInsets.fromLTRB(16, 40, 16, 8),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          ),
          child: const Icon(Icons.arrow_back_ios_new,
              size: 18, color: AppStyle.primary),
        ),
      ),

      // Botón agregar cama
      InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddBedAdminView()),
          );
        },
        borderRadius: BorderRadius.circular(30),
        child: const Icon(Icons.add_circle,
            size: 32, color: Colors.green),
      ),
    ],
  ),
),

// 🔹 Título debajo, ocupa todo el ancho
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  child: Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppStyle.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: const [
        Icon(Icons.bed_rounded, size: 36, color: AppStyle.primary),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            "Administración de Camas",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.visible, // nunca lo corta
          ),
        ),
      ],
    ),
  ),
),

  


          // Tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppStyle.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: AppStyle.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppStyle.primary,
              tabs: const [
                Tab(text: "Todas"),
                Tab(text: "Por salas"),
              ],
            ),
          ),

          // Contenido de pestañas
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // TAB 1 - Todas las camas
                Consumer<BedsAdminProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading == true) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (provider.allBeds.isEmpty) {
                      return const Center(
                          child: Text("No hay camas registradas"));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: provider.allBeds.length,
                      itemBuilder: (context, index) {
                        final bed = provider.allBeds[index];
                        return BedAdminCard(bed: bed);
                      },
                    );
                  },
                ),

                // TAB 2 - Por salas
                Consumer<RoomsAdminProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (provider.rooms.isEmpty) {
                      return const Center(
                          child: Text("No hay salas registradas"));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: provider.rooms.length,
                      itemBuilder: (context, index) {
                        final room = provider.rooms[index];
                        return BedRoomCard(
                          room: room,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BedsByRoomView(room: room),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
