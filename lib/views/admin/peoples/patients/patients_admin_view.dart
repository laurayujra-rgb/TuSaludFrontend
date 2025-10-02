import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/admin/people_admin_provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/widgets/admin/people/patients/patients_admin_card.dart';
import 'package:tusalud/views/admin/peoples/patients/add_patients_admin_view.dart';

class PatientsAdminView extends StatelessWidget {
  static const String routerName = 'patientsAdmin';
  static const String routerPath = '/patients_admin';

  const PatientsAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PeopleAdminProvider()..loadPeopleByRole(4), // roleId = 4
      child: Scaffold(
        backgroundColor: AppStyle.ligthGrey,
        body: Column(
          children: [
            // 🔹 Header con botones arriba
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 40, 16, 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Botón atrás
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppStyle.white,
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 20,
                            color: AppStyle.primary,
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Botón agregar paciente
                      InkWell(
                        onTap: () async {
                          final result = await context.push<bool>(AddPatientView.routerPath);
                          if (result == true && context.mounted) {
                            Provider.of<PeopleAdminProvider>(context, listen: false)
                                .loadPeopleByRole(4);
                          }
                        },
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 26,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Título centrado
                  const Text(
                    "Gestión de Pacientes",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // 🔹 Listado de pacientes
            Expanded(
              child: Consumer<PeopleAdminProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (provider.errorMessage != null) {
                    return Center(child: Text(provider.errorMessage!));
                  }
                  if (provider.people.isEmpty) {
                    return const Center(
                        child: Text("No hay pacientes registrados"));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: provider.people.length,
                    itemBuilder: (context, index) {
                      final person = provider.people[index];
                      return PatientAdminCard(person: person);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
