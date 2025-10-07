// lib/views/admin/peoples/patients/add_patients_admin_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/admin/gender_provider.dart';
import 'package:tusalud/providers/admin/register_patient_provider.dart';
import 'package:tusalud/providers/admin/rooms_admin_provider.dart';
import 'package:tusalud/providers/admin/beds_admin_provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/widgets/admin/people/patients/add_patients_admin_card.dart';
import 'package:tusalud/widgets/app/custom_app_bar.dart';

class AddPatientView extends StatelessWidget {
  static const String routerName = 'addPatient';
  static const String routerPath = '/add_patient';

  const AddPatientView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GenderAdminProvider()..loadGenders()),
        ChangeNotifierProvider(create: (_) => RoomsAdminProvider()..loadRooms()),
        ChangeNotifierProvider(create: (_) => BedsAdminProvider()),
        ChangeNotifierProvider(create: (_) => RegisterPatientProvider()),
      ],
      child: Scaffold(
        appBar: const CustomAppBar(
          text: "Nuevo Paciente",
          centerTitle: true,
        ),
        backgroundColor: AppStyle.ligthGrey,
        body: const Padding(
          padding: EdgeInsets.all(16),
          child: AddPatientCard(),
        ),
      ),
    );
  }
}
