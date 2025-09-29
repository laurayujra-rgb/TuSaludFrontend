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
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        "Gestión de Pacientes",
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

            // Listado
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

        // 🔹 Botón para agregar paciente con go_router
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppStyle.primary,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text("Nuevo Paciente"),
          onPressed: () {
            context.push(AddPatientView.routerPath);
          },
        ),
      ),
    );
  }
}
