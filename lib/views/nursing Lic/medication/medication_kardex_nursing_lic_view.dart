import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/nursing%20Lic/kardex_nursing_lic_provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/widgets/nursing%20Lic/medication/medication_kardex_nursing_lic_card.dart';
import 'package:tusalud/views/nursing%20Lic/medication/medication_list_nursing_lic_view.dart';

class MedicationKardexNursingLicView extends StatefulWidget {
  static const String routerName = 'medicationKardexNursingLic';
  static const String routerPath = '/medication_kardex_nursing_lic';

  final int patientId;
  final String? headerSubtitle;

  const MedicationKardexNursingLicView({
    super.key,
    required this.patientId,
    this.headerSubtitle,
  });

  @override
  State<MedicationKardexNursingLicView> createState() =>
      _MedicationKardexNursingLicViewState();
}

class _MedicationKardexNursingLicViewState
    extends State<MedicationKardexNursingLicView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<KardexNursingLicProvider>(context, listen: false)
            .loadKardexByPatientAndRole(widget.patientId, 4));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.ligthGrey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: AppStyle.primary),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Gestión de Medicación",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppStyle.primary,
              ),
            ),
            if (widget.headerSubtitle != null)
              Text(
                widget.headerSubtitle!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
          ],
        ),
      ),
      body: Consumer<KardexNursingLicProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          }
          if (provider.kardexList.isEmpty) {
            return const Center(
              child: Text(
                "Este paciente no tiene Kardex registrados",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            itemCount: provider.kardexList.length,
            itemBuilder: (context, index) {
              final kardex = provider.kardexList[index];
              return MedicationKardexNursingLicCard(
                kardex: kardex,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MedicationListNursingLicView(
                        kardexId: kardex.kardexId,
                        headerSubtitle:
                            "Kardex #${kardex.kardexNumber} - ${kardex.kardexDiagnosis}",
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
