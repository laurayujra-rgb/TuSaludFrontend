import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/nursing%20Lic/patients_nursing_lic_provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/views/nursing%20Lic/medication/medication_kardex_nursing_lic_view.dart';
import 'package:tusalud/widgets/nursing%20Lic/patients/patients_nursing_lic_card.dart';
import 'package:go_router/go_router.dart';

import 'package:tusalud/views/nursing%20Lic/kardex/kardex_nursing_lic_view.dart';

class PatientsNursingLicView extends StatefulWidget {
  static const String routerName = 'patientsNursingLic';
  static const String routerPath = '/patientsNursingLic';

  final String? headerSubtitle;

  const PatientsNursingLicView({super.key, this.headerSubtitle});

  @override
  State<PatientsNursingLicView> createState() => _PatientsNursingLicViewState();
}

class _PatientsNursingLicViewState extends State<PatientsNursingLicView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<PatientsNursingLicProvider>(context, listen: false)
            .loadPatients());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.ligthGrey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.people_alt_rounded, color: Colors.white, size: 26),
            SizedBox(width: 8),
            Text(
              "Gestión de Pacientes",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
      body: Consumer<PatientsNursingLicProvider>(
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
          if (provider.patients.isEmpty) {
            return const Center(
              child: Text(
                "No hay pacientes registrados",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(top: 12, bottom: 24),
            itemCount: provider.patients.length,
            itemBuilder: (context, index) {
              final patient = provider.patients[index];
              return PatientsNursingLicCard(
                patient: patient,
                onKardex: () {
                  context.pushNamed(
                    KardexNursingLicView.routerName,
                    queryParameters: {
                      'patientId': patient.personId.toString(),
                      'headerSubtitle':
                          "Paciente: ${patient.personName} ${patient.personFahterSurname ?? ''}",
                    },
                  );
                },
onMedication: () {
  context.pushNamed(
    MedicationKardexNursingLicView.routerName, // ✅ usar la vista de medicación
    queryParameters: {
      'patientId': patient.personId.toString(),
      'headerSubtitle':
          "Paciente: ${patient.personName} ${patient.personFahterSurname ?? ''}",
    },
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
