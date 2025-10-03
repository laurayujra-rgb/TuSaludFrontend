import 'package:flutter/material.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/views/admin/hospital/bed/beds_admin_view.dart';
import 'package:tusalud/views/admin/hospital/rooms/room_admin_view.dart';
import 'package:tusalud/views/admin/settings/diet/diet_admin_view.dart';
import 'package:tusalud/views/admin/settings/gender/gender_admin_view.dart';
import 'package:tusalud/views/admin/settings/role/role_admin_view.dart';
import 'package:tusalud/views/admin/settings/via%20Medicine/via_admin_view.dart';
import 'package:tusalud/views/admin/settings/medicine/medicine_nursing_lic_view.dart';
import 'package:tusalud/widgets/admin/Hospital/settings_admin_card.dart';

class SettingsAdminView extends StatelessWidget {
  static const String routerName = 'settings_admin';
  static const String routerPath = '/settings_admin';

  const SettingsAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppStyle.ligthGrey,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppStyle.ligthGrey,
          title: const Text(""),
        ),
        body: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                width: double.infinity,
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
                        Icons.local_hospital,
                        size: 36,
                        color: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        "Gestión del Hospital",
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
            ),

            // Contenido con ListView
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    SettingsAdminCard(
                      title: "Gestión de Géneros",
                      subtitle: "Configura los géneros del sistema",
                      icon: Icons.wc,
                      color: Colors.teal.shade50,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const GenderAdminView(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    SettingsAdminCard(
                      title: "Gestión de Roles",
                      subtitle: "Administra los roles de usuario",
                      icon: Icons.admin_panel_settings,
                      color: Colors.deepPurple.shade50,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RoleAdminView(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    SettingsAdminCard(
                      title: "Medicamentos",
                      subtitle: "Controla los medicamentos registrados",
                      icon: Icons.medication,
                      color: Colors.green.shade50,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MedicineNurseView(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    SettingsAdminCard(
                      title: "Dietas",
                      subtitle: "Gestiona los tipos de dieta",
                      icon: Icons.restaurant_menu,
                      color: Colors.orange.shade50,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DietAdminView(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    SettingsAdminCard(
                      title: "Tipos de Vías de Administración",
                      subtitle: "Oral, Intravenosa, Intramuscular, etc.",
                      icon: Icons.local_pharmacy,
                      color: Colors.purple.shade50,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ViasView(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    SettingsAdminCard(
                      title: "Administración de Salas",
                      subtitle: "Gestiona las diferentes salas hospitalarias",
                      icon: Icons.local_hotel,
                      color: Colors.blue.shade50,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RoomsAdminView(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    SettingsAdminCard(
                      title: "Administración de Camas",
                      subtitle: "Controla el estado y asignación de camas",
                      icon: Icons.airline_seat_individual_suite_rounded,
                      color: Colors.green.shade50,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const BedsAdminView(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
