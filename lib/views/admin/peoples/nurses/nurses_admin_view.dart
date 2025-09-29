import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:tusalud/providers/admin/people_admin_provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/views/admin/peoples/nurses/add_nurse_admin_view.dart';
import 'package:tusalud/widgets/admin/people/nurse/nurses_admin_card.dart';

class NursesAdminView extends StatelessWidget {
  static const String routerName = 'nursesAdmin';
  static const String routerPath = '/nurses_admin';

  const NursesAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PeopleAdminProvider()..loadPeopleByRole(2), // roleId = 2
      child: Scaffold(
        backgroundColor: AppStyle.ligthGrey,
        body: Column(
          children: [
            // 🔹 Header
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
                        color: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        "Gestión de Enfermeras",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    // 🔹 Botón Agregar Enfermera
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.add, size: 20),
                      label: const Text(
                        "Agregar",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        context.push(AddNurseAdminView.routerPath);
                      },
                    ),
                  ],
                ),
              ),
            ),

            // 🔹 Listado
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
                        child: Text("No hay enfermeras registradas"));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: provider.people.length,
                    itemBuilder: (context, index) {
                      final person = provider.people[index];
                      return NurseAdminCard(person: person);
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
