import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/nurse/medicine_nurse_provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/widgets/nurse/medicine_nurse_card.dart';

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
    return Scaffold(
      backgroundColor: AppStyle.ligthGrey,
      body: Column(
        children: [
          // 🔹 Header estilo widget
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 30, 16, 12),
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
                    child: const Icon(Icons.medical_services,
                        size: 36, color: AppStyle.primary),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      "Gestión de Medicamentos 💊",
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
    );
  }
}
