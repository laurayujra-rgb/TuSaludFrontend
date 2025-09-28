import 'package:flutter/material.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/views/admin/rooms/room_admin_view.dart';
import 'package:tusalud/widgets/admin/hospital_option_card.dart';
import 'package:tusalud/views/admin/bed/beds_admin_view.dart';

class HospitalAdminView extends StatelessWidget {
  static const String routerName = 'hospital';
  static const String routerPath = '/hospital';

  const HospitalAdminView({super.key});

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
            // Header en forma de Card
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

            // Opciones
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    HospitalOptionCard(
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
                    HospitalOptionCard(
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
