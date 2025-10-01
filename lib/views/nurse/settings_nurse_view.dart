import 'package:flutter/material.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/views/nursing%20Lic/diet/diet_nurse_view.dart';
import 'package:tusalud/views/nursing%20Lic/medicine/medicine_nursing_lic_view.dart';
import 'package:tusalud/views/nursing%20Lic/via%20Medicine/via_nurse_view.dart';


// Vistas a redireccionar

import 'package:tusalud/widgets/nurse/settings_nurse_card.dart';

class SettingsView extends StatelessWidget {
  static const String routerName = 'settings';
  static const String routerPath = '/settings';

  const SettingsView({super.key});

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
                        Icons.settings,
                        size: 36,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        "Configuración de la App",
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
                    SettingsOptionCard(
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
                    SettingsOptionCard(
                      title: "Dietas",
                      subtitle: "Gestiona los tipos de dieta",
                      icon: Icons.restaurant_menu,
                      color: Colors.orange.shade50,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DietNurseView(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    SettingsOptionCard(
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
