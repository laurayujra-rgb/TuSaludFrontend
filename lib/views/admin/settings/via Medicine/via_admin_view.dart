import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/admin/via_admin_provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/views/admin/settings/via%20Medicine/add_via_admin_view.dart';
import 'package:tusalud/widgets/admin/settings/via%20Medicine/via_admin_card.dart';

class ViasView extends StatefulWidget {
  static const String routerName = 'viasAdmin';
  static const String routerPath = '/vias_admin';

  const ViasView({super.key});

  @override
  State<ViasView> createState() => _ViasViewState();
}

class _ViasViewState extends State<ViasView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<ViaAdminProvider>(context, listen: false).loadVias());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppStyle.ligthGrey,
        appBar: AppBar(
          backgroundColor: AppStyle.ligthGrey,
          elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.add, color: AppStyle.primary),
                tooltip: "Agregar nueva vía",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddViaAdminView(),
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
                        Icons.route, // Icono distinto al hospital
                        size: 36,
                        color: AppStyle.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        "Administración de Vías",
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
              child: Consumer<ViaAdminProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (provider.errorMessage != null) {
                    return Center(child: Text(provider.errorMessage!));
                  }
                  if (provider.vias.isEmpty) {
                    return const Center(child: Text("No hay vías registradas"));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: provider.vias.length,
                    itemBuilder: (context, index) {
                      final via = provider.vias[index];
                      return ViaCard(
                        via: via,
                        onEdit: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Editar vía: ${via.viaName}")),
                          );
                        },
                        onDelete: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Eliminar vía: ${via.viaName}")),
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
