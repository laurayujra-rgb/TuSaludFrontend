import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/nursing%20Lic/kardex_nursing_lic_provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/views/nursing%20Lic/kardex/add_kardex_nursing_lic_view.dart';
import 'package:tusalud/widgets/nursing%20Lic/kardex/kardex_nursing_lic_card.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/admin/diet_admin_provider.dart';
import 'package:tusalud/providers/admin/people_admin_provider.dart';

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
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: provider.kardexList.length,
                  itemBuilder: (context, index) {
                    final kardex = provider.kardexList[index];
                    return KardexNursingLicCard(
                      kardex: kardex,
                      onEdit: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Editar kardex: ${kardex.kardexNumber}")),
                        );
                      },
                      onDelete: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Eliminar kardex: ${kardex.kardexNumber}")),
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
