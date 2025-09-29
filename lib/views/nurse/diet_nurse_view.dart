import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/nurse/diet_nurse_provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/widgets/nurse/diet_nurse_card.dart';

class DietNurseView extends StatefulWidget {
  static const String routerName = 'dietsNurse';
  static const String routerPath = '/diets_nurse';

  const DietNurseView({super.key});

  @override
  State<DietNurseView> createState() => _DietNurseViewState();
}

class _DietNurseViewState extends State<DietNurseView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<DietNurseProvider>(context, listen: false).loadDiets());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.ligthGrey,
      body: Column(
        children: [
          const SizedBox(height: 30),
          // 🔹 Header estilo tarjeta
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
                      Icons.restaurant_menu,
                      size: 36,
                      color: AppStyle.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      "🍽️ Tipos de Dieta",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Agregar nueva dieta")),
                      );
                    },
                    icon: const Icon(Icons.add_circle,
                        size: 32, color: Colors.green),
                  ),
                ],
              ),
            ),
          ),

          // 🔹 Listado
          Expanded(
            child: Consumer<DietNurseProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.errorMessage != null) {
                  return Center(child: Text(provider.errorMessage!));
                }
                if (provider.diets.isEmpty) {
                  return const Center(
                    child: Text("No hay dietas registradas"),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: provider.diets.length,
                  itemBuilder: (context, index) {
                    final diet = provider.diets[index];
                    return DietNurseCard(
                      diet: diet,
                      onEdit: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Editar dieta: ${diet.dietName}")),
                        );
                      },
                      onDelete: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text("Eliminar dieta: ${diet.dietName}")),
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
    );
  }
}
