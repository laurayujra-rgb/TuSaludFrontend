import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/providers/admin/diet_admin_provider.dart';
import 'package:tusalud/providers/admin/people_admin_provider.dart';
import 'package:tusalud/widgets/nursing%20Lic/kardex/add_kardex_nursing_lic_card.dart';

class AddKardexNursingLicView extends StatelessWidget {
  static const String routerName = 'addKardexNursingLic';
  static const String routerPath = '/add_kardex_nursing_lic';


  final int patientId;

  const AddKardexNursingLicView({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DietAdminProvider()),
        ChangeNotifierProvider(create: (_) => PeopleAdminProvider()),
      ],
      child: Scaffold(
        backgroundColor: AppStyle.ligthGrey,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 🔹 Header
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppStyle.primary, Colors.blueAccent],
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
                      Icon(Icons.assignment_add, size: 36, color: Colors.white),
                      SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          "Nuevo Kardex",
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

                // 🔹 Formulario
                AddKardexNursingLicCard(patientId: patientId),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
