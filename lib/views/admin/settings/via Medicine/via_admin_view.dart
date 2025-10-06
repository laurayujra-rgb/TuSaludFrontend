import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/admin/via_admin_provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/views/admin/settings/via Medicine/add_via_admin_view.dart';
import 'package:tusalud/widgets/admin/Hospital/via Medicine/via_admin_card.dart'; // <- usa la nueva card

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
                  MaterialPageRoute(builder: (_) => const AddViaAdminView()),
                ).then((_) {
                  // 🔄 Refresca al volver
                  Provider.of<ViaAdminProvider>(context, listen: false)
                      .loadVias();
                });
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Header bonito
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
                        Icons.route,
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

            // Listado
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

                      return ViaAdminCard(
                        via: via,

                        // (Opcional) Tap principal
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Seleccionaste ${via.viaName}")),
                          );
                        },

                      
                        onEdit: () async {
                          final controller = TextEditingController(text: via.viaName);
                          final newName = await showDialog<String>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Editar vía"),
                              content: TextField(
                                controller: controller,
                                decoration: const InputDecoration(
                                  labelText: "Nuevo nombre",
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text("Cancelar"),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(ctx, controller.text.trim()),
                                  child: const Text("Guardar"),
                                ),
                              ],
                            ),
                          );

                          if (newName != null && newName.isNotEmpty) {
                            await Provider.of<ViaAdminProvider>(context, listen: false)
                                .updateVia(via.viaId, newName);

                            // 🟢 Verificamos si el contexto sigue montado
                            if (!context.mounted) return;

                            final err = Provider.of<ViaAdminProvider>(context, listen: false).errorMessage;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(err == null ? "✅ Vía actualizada" : "❌ $err"),
                              ),
                            );
                          }
                        },


                        onDelete: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Eliminar vía"),
                              content: Text("¿Deseas eliminar la vía '${via.viaName}'?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text("Cancelar"),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text("Eliminar"),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            await Provider.of<ViaAdminProvider>(context, listen: false)
                                .deleteVia(via.viaId);

                            // 🟢 Verificamos antes de usar context
                            if (!context.mounted) return;

                            final err = Provider.of<ViaAdminProvider>(context, listen: false).errorMessage;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(err == null ? "🗑️ Vía eliminada" : "❌ $err"),
                              ),
                            );
                          }
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
