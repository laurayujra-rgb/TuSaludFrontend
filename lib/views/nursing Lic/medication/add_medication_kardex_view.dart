import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/admin/medicine_nurse_provider.dart';
import 'package:tusalud/providers/nursing%20Lic/medication_kardex_nursing_lic_provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/widgets/nursing%20Lic/medication/add_medication_kardex_card.dart';

class AddMedicationKardexView extends StatelessWidget {
  final int kardexId;

  const AddMedicationKardexView({super.key, required this.kardexId});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MedicationKardexNursingLicProvider()),
        ChangeNotifierProvider(create: (_) => MedicineNurseProvider()..loadMedicines()),
      ],
      child: Scaffold(
        backgroundColor: AppStyle.ligthGrey,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppStyle.primary,
          title: const Text(
            "Agregar Medicamento",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: AddMedicationKardexCard(kardexId: kardexId),
          ),
        ),
      ),
    );
  }
}
