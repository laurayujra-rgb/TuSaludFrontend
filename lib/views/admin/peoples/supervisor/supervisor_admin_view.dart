import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/admin/people_admin_provider.dart';
import 'package:tusalud/views/admin/peoples/supervisor/add_supervisor_Admin_view.dart';
import 'package:tusalud/widgets/admin/people/supervisor/supervisor_admin_card.dart';
import 'package:tusalud/style/app_style.dart';

class SupervisorsAdminView extends StatelessWidget {
  static const String routerName = 'supervisorsAdmin';
  static const String routerPath = '/supervisors_admin';

  const SupervisorsAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PeopleAdminProvider()..loadPeopleByRole(3), // roleId = 3
      child: Scaffold(
        backgroundColor: AppStyle.ligthGrey,
        body: Column(
          children: [
            // Header + botón agregar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
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
                              Icons.supervisor_account,
                              size: 36,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Text(
                              "Gestión de Supervisoras",
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
                  const SizedBox(width: 12),
                  // Botón agregar supervisora
                  InkWell(
                    onTap: () async {
                      final created = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddSupervisorAdminView(),
                        ),
                      );
                      if (created == true && context.mounted) {
                        context.read<PeopleAdminProvider>().loadPeopleByRole(3);
                      }
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.deepPurple,
                      ),
                      child: const Icon(Icons.add, color: Colors.white, size: 26),
                    ),
                  ),
                ],
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
                    return const Center(child: Text("No hay supervisoras registradas"));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: provider.people.length,
                    itemBuilder: (context, index) {
                      final person = provider.people[index];
                      return SupervisorAdminCard(person: person);
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
