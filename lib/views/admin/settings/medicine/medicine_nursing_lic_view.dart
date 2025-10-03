import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/admin/medicine_nurse_provider.dart';
import 'package:tusalud/style/app_style.dart';
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
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Editar ${medicine.medicineName}")),
                          );
                        },
                        onDelete: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Eliminar ${medicine.medicineName}")),
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
