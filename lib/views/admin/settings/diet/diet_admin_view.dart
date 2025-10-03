import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/admin/diet_admin_provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/views/admin/settings/diet/add_diet_admin_view.dart';
import 'package:tusalud/widgets/admin/Hospital/diet/diet_admin_card.dart';

class DietAdminView extends StatefulWidget {
  static const String routerName = 'dietsAdmin';
  static const String routerPath = '/diets_admin';

  const DietAdminView({super.key});

  @override
  State<DietAdminView> createState() => _DietAdminViewState();
}

class _DietAdminViewState extends State<DietAdminView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<DietAdminProvider>(context, listen: false).loadDiets());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppStyle.ligthGrey,
        appBar: AppBar(
          backgroundColor: AppStyle.ligthGrey,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppStyle.primary),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add, color: AppStyle.primary),
              tooltip: "Agregar nueva dieta",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddDietAdminView(),
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // 🔹 Header con tarjeta moderna
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
                        Icons.restaurant_menu,
                        size: 36,
                        color: AppStyle.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        "Administración de Dietas",
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

            // 🔹 Listado
            Expanded(
              child: Consumer<DietAdminProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (provider.errorMessage != null) {
                    return Center(child: Text(provider.errorMessage!));
                  }
                  if (provider.diets.isEmpty) {
                    return const Center(child: Text("No hay dietas registradas"));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: provider.diets.length,
                    itemBuilder: (context, index) {
                      final diet = provider.diets[index];
                      return DietNurseCard(
                        diet: diet,
                        onEdit: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Editar dieta: ${diet.dietName}")),
                          );
                        },
                        onDelete: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Eliminar dieta: ${diet.dietName}")),
                          );
                        },
                      );
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
