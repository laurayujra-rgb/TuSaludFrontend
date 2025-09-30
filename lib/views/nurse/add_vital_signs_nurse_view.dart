import 'package:flutter/material.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/widgets/nurse/add_vital_signs_nurse_card.dart';

class AddVitalSignNurseView extends StatelessWidget {
  static const String routerName = 'addVitalSignNurse';
  static const String routerPath = '/add_vital_sign_nurse';

  final int kardexId;

  const AddVitalSignNurseView({super.key, required this.kardexId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.ligthGrey,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 🔹 Header con diseño
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppStyle.primary, AppStyle.accent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: const [
                    Icon(Icons.monitor_heart, size: 36, color: Colors.white),
                    SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        "Nuevo Signo Vital",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 🔹 Formulario con estilo
              AddVitalSignNurseCard(kardexId: kardexId),
            ],
          ),
        ),
      ),
    );
  }
}
