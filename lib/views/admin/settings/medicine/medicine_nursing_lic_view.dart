import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/admin/medicine_nurse_provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/views/admin/settings/medicine/edit_medicine_view.dart';
import 'package:tusalud/widgets/admin/Hospital/medicine/medicine_nurse_card.dart';
import 'package:tusalud/views/admin/settings/medicine/add_medicine_admin_view.dart'; // 👈 importa la vista de agregar

class MedicineNurseView extends StatefulWidget {
  static const String routerName = 'medicineNurse';
  static const String routerPath = '/medicine_nurse';

  const MedicineNurseView({super.key});

  @override
  State<MedicineNurseView> createState() => _MedicineNurseViewState();
}

class _MedicineNurseViewState extends State<MedicineNurseView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<MedicineNurseProvider>(context, listen: false).loadMedicines());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppStyle.ligthGrey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppStyle.primary),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Gestión de Medicamentos",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.green, size: 28),
              tooltip: "Agregar nuevo medicamento",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AddMedicineAdminView(),
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // 🔹 Header tipo tarjeta
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppStyle.primary.withOpacity(0.9), Colors.blueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(2, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: const [
                    Icon(Icons.medical_services,
                        size: 36, color: Colors.white),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        "Listado de Medicamentos 💊",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 🔹 Contenido dinámico
            Expanded(
              child: Consumer<MedicineNurseProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (provider.errorMessage != null) {
                    return Center(child: Text(provider.errorMessage!));
                  }
                  if (provider.medicines.isEmpty) {
                    return const Center(child: Text("No hay medicamentos registrados"));
                  }
                  return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: provider.medicines.length,
                  itemBuilder: (context, index) {
                    final medicine = provider.medicines[index];
                    return MedicineNurseCard(
                      medicine: medicine,
                      onEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditMedicineAdminView(medicine: medicine),
                          ),
                        );
                      },
                      onDelete: () async {
                        // 🔹 Confirmación antes de eliminar
                        final confirm = await showDialog<bool>(
                          context: context,
                          barrierDismissible: false,
                          builder: (ctx) => AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            title: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.warning_amber_rounded, color: Colors.red, size: 48),
                                SizedBox(height: 10),
                                Text(
                                  "¿Eliminar medicamento?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            content: Text(
                              "Esta acción desactivará \"${medicine.medicineName}\".\n¿Deseas continuar?",
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16, color: Colors.black54, height: 1.4),
                            ),
                            actionsAlignment: MainAxisAlignment.center,
                            actionsPadding: const EdgeInsets.only(bottom: 10, top: 5),
                            actions: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: SizedBox(
                                  width: 110,
                                  height: 42,
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(color: Colors.grey),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)),
                                    ),
                                    onPressed: () => Navigator.pop(ctx, false),
                                    child: const Text(
                                      "Cancelar",
                                      style: TextStyle(
                                          color: Colors.black87, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: SizedBox(
                                  width: 110,
                                  height: 42,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)),
                                    ),
                                    onPressed: () => Navigator.pop(ctx, true),
                                    child: const Text(
                                      "Eliminar",
                                      style: TextStyle(
                                          color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );

                        // 🔹 Eliminar si el usuario confirma
                        if (confirm == true) {
                          await Provider.of<MedicineNurseProvider>(context, listen: false)
                              .deleteMedicine(medicine.medicineId);

                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("✅ ${medicine.medicineName} eliminado correctamente"),
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
