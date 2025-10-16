import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/nursing%20Lic/kardex_nursing_lic_provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/views/nursing%20Lic/kardex/add_kardex_nursing_lic_view.dart';
import 'package:tusalud/views/nursing%20Lic/kardex/edit_kardex_nursing_lic_view.dart' show EditKardexNursingLicView;
import 'package:tusalud/widgets/nursing%20Lic/kardex/kardex_nursing_lic_card.dart';


class KardexNursingLicView extends StatefulWidget {
  static const String routerName = 'kardexNursingLic';
  static const String routerPath = '/kardex_nursing_lic';

  final int patientId;
  final String? headerSubtitle;

  const KardexNursingLicView({
    super.key,
    required this.patientId,
    this.headerSubtitle,
  });

  @override
  State<KardexNursingLicView> createState() => _KardexNursingLicViewState();
}

class _KardexNursingLicViewState extends State<KardexNursingLicView> {
@override
void initState() {
  super.initState();
  Future.microtask(() =>
      Provider.of<KardexNursingLicProvider>(context, listen: false)
          .loadKardexByPatientAndRole(widget.patientId, 4));
}


  @override
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppStyle.ligthGrey,
    body: SafeArea(
      child: Column(
        children: [
          // 🔹 Header
          Container(
            margin: const EdgeInsets.fromLTRB(16, 20, 16, 10),
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
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppStyle.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.assignment, size: 32, color: AppStyle.primary),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    "Gestión de Kardex",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, size: 32, color: AppStyle.primary),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddKardexNursingLicView(
                          patientId: widget.patientId, // ✅ solo esto
                        ),
                      ),
                    );

                  },
                )
              ],
            ),
          ),

          // 🔹 Buscador
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Buscar por diagnóstico o enfermera...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (query) {
                Provider.of<KardexNursingLicProvider>(context, listen: false)
                    .searchKardex(query);
              },
            ),
          ),

          // 🔹 Lista de Kardex
          Expanded(
            child: Consumer<KardexNursingLicProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.errorMessage != null) {
                  return Center(child: Text(provider.errorMessage!));
                }
                if (provider.kardexList.isEmpty) {
                  return const Center(
                    child: Text("Este paciente no tiene kardex registrados..."),
                  );
                }

                    return ListView.builder(
                      itemCount: provider.kardexList.length,
                      itemBuilder: (context, index) {
                        final kardex = provider.kardexList[index];

                        return Dismissible(
                          key: ValueKey(kardex.kardexId),
                          background: Container(
                            color: Colors.blueAccent,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20),
                            child: const Icon(Icons.edit, color: Colors.white),
                          ),
                          secondaryBackground: Container(
                            color: Colors.redAccent,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                            confirmDismiss: (direction) async {
                              final rootContext = context; // ✅ contexto seguro

                              if (direction == DismissDirection.startToEnd) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditKardexNursingLicView(
                                      kardex: kardex,
                                      patientId: widget.patientId,
                                    ),
                                  ),
                                );
                                return false;
                              }

                              if (direction == DismissDirection.endToStart) {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text("Confirmar eliminación"),
                                    content: const Text("¿Deseas eliminar este Kardex?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(_, false),
                                        child: const Text("Cancelar"),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(_, true),
                                        child: const Text("Eliminar"),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  final kardexProvider =
                                      Provider.of<KardexNursingLicProvider>(rootContext, listen: false);
                                  final deleted = await kardexProvider.deleteKardex(kardex.kardexId);

                                  if (deleted && mounted) {
                                    ScaffoldMessenger.of(rootContext).showSnackBar(
                                      const SnackBar(content: Text("🗑️ Kardex eliminado correctamente")),
                                    );
                                  } else if (mounted) {
                                    ScaffoldMessenger.of(rootContext).showSnackBar(
                                      const SnackBar(content: Text("❌ Error al eliminar el kardex")),
                                    );
                                  }
                                }
                              }

                              return false;
                            },

                          child: KardexNursingLicCard(kardex: kardex),
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
