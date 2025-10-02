import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
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
            const SizedBox(height: 40),

            // 🔹 Botón atrás + título + agregar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Botón atrás
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_ios_new,
                          size: 18, color: AppStyle.primary),
                    ),
                  ),

                  const Spacer(),

                  // Botón agregar
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text(
                      "Agregar",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      final result =
                          await context.push<bool>(AddNurseAdminView.routerPath);

                      // ✅ Si vuelve con true → recargamos lista
                      if (result == true && context.mounted) {
                        Provider.of<PeopleAdminProvider>(context, listen: false)
                            .loadPeopleByRole(2);
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 🔹 Título centrado
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Gestión de Enfermeras",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            const SizedBox(height: 16),

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
