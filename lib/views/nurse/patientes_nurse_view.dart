import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/nurse/patients_nurse_provider.dart';
import 'package:tusalud/style/app_style.dart';
import '../../widgets/nurse/patients_nurse_card.dart';

class PatientsNurseView extends StatefulWidget {
  static const String routerName = 'patientsNurse';
  static const String routerPath = '/patients_nurse';

  const PatientsNurseView({super.key});

  @override
  State<PatientsNurseView> createState() => _PatientsNurseViewState();
}

class _PatientsNurseViewState extends State<PatientsNurseView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<PatientsNurseProvider>(context, listen: false).loadPatients());
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
      body: Consumer<PatientsNurseProvider>(
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
              return PatientsNurseCard(
                patient: patient,
                onMedication: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Medicación de ${patient.personName}")),
                  );
                },
                onKardex: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Kardex de ${patient.personName}")),
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
