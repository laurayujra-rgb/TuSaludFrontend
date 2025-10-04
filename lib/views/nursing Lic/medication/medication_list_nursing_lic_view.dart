import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/nursing%20Lic/medication_kardex_nursing_lic_provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/widgets/nursing%20Lic/medication/medication_card.dart';

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
                    return MedicationCard(medication: medication);
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
