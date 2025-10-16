import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/nursing%20Lic/medication_kardex_nursing_lic_provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/views/nursing%20Lic/medication/EditMedicationKardexView.dart';
import 'package:tusalud/widgets/nursing%20Lic/medication/medication_card.dart';
import 'package:tusalud/views/nursing%20Lic/medication/add_medication_kardex_view.dart';

class MedicationListNursingLicView extends StatefulWidget {
  static const String routerName = 'medicationListNursingLic';
  static const String routerPath = '/medication_list_nursing_lic';

  final int kardexId;
  final String? headerSubtitle;

  const MedicationListNursingLicView({
    super.key,
    required this.kardexId,
    this.headerSubtitle,
  });

  @override
  State<MedicationListNursingLicView> createState() =>
      _MedicationListNursingLicViewState();
}

class _MedicationListNursingLicViewState
    extends State<MedicationListNursingLicView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<MedicationKardexNursingLicProvider>(context, listen: false)
            .loadMedicationsByKardex(widget.kardexId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.ligthGrey,
      body: Column(
        children: [
          // 🔹 Header elegante
          Container(
            padding: const EdgeInsets.only(top: 50, bottom: 24, left: 20, right: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppStyle.primary, Colors.blueAccent.shade200],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Botón Back
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.arrow_back, color: AppStyle.primary),
                  ),
                ),
                const SizedBox(height: 16),

                // 🔹 Título principal
                const Text(
                  "Medicamentos del Kardex",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                // 🔹 Subtítulo
                if (widget.headerSubtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      widget.headerSubtitle!,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // 🔹 Contenido
          Expanded(
            child: Consumer<MedicationKardexNursingLicProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.errorMessage != null) {
                  return Center(
                    child: Text(
                      provider.errorMessage!,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  );
                }
                if (provider.medications.isEmpty) {
                  return const Center(
                    child: Text(
                      "Este Kardex no tiene medicamentos registrados",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  );
                }

return ListView.builder(
  padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
  itemCount: provider.medications.length,
  itemBuilder: (context, index) {
    final medication = provider.medications[index];
    return Dismissible(
      key: ValueKey(medication.id),
      background: Container(
        color: Colors.blueAccent,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.edit, color: Colors.white, size: 28),
      ),
      secondaryBackground: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // 👉 Editar
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditMedicationKardexView(
                medication: medication,
              ),
            ),
          );
          if (result == true) {
            Provider.of<MedicationKardexNursingLicProvider>(context, listen: false)
                .loadMedicationsByKardex(widget.kardexId);
          }
          return false;
        } else if (direction == DismissDirection.endToStart) {
          // 👉 Eliminar
          final confirm = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("Eliminar medicación"),
              content: const Text("¿Deseas eliminar este medicamento del Kardex?"),
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
            await Provider.of<MedicationKardexNursingLicProvider>(context, listen: false)
                .deleteMedication(medication.id);
          }
          return false;
        }
        return false;
      },
      child: MedicationCard(medication: medication),
    );
  },
);

              },
            ),
          ),
        ],
      ),

      // 🔹 Botón flotante para agregar medicamentos
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppStyle.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Agregar"),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddMedicationKardexView(kardexId: widget.kardexId),
            ),
          );

          // ✅ Si guardó correctamente, recargar la lista
          if (result == true) {
            Provider.of<MedicationKardexNursingLicProvider>(context, listen: false)
                .loadMedicationsByKardex(widget.kardexId);
          }
        },
      ),
    );
  }
}
