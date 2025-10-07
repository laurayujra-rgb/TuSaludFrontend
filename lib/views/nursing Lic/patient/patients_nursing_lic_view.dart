// patients_nursing_lic_view.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:tusalud/providers/nursing Lic/patients_nursing_lic_provider.dart';
import 'package:tusalud/providers/admin/rooms_admin_provider.dart';

import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/widgets/nursing Lic/patients/patients_nursing_lic_card.dart';

import 'package:tusalud/views/nursing Lic/kardex/kardex_nursing_lic_view.dart';
import 'package:tusalud/views/nursing Lic/medication/medication_kardex_nursing_lic_view.dart';

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
    Future.microtask(() {
      Provider.of<PatientsNursingLicProvider>(context, listen: false)
          .loadPatients();
      Provider.of<RoomsAdminProvider>(context, listen: false)
          .loadRooms();
    });
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
      body: Column(
        children: [
          // Filtro por sala
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Consumer2<PatientsNursingLicProvider, RoomsAdminProvider>(
              builder: (context, patientsProv, roomsProv, _) {
                return Container(
                  decoration: BoxDecoration(
                    color: AppStyle.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 6,
                        offset: const Offset(2, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.meeting_room, color: AppStyle.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<int?>(
                          value: patientsProv.selectedRoomId,
                          isExpanded: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Filtrar por Sala",
                          ),
                          items: [
                            const DropdownMenuItem<int?>(
                              value: null,
                              child: Text("Todas las salas"),
                            ),
                            ...roomsProv.rooms.map((r) => DropdownMenuItem<int?>(
                                  value: r.roomId,
                                  child: Text(r.roomName ?? "Sala ${r.roomId}"),
                                )),
                          ],
                          onChanged: (val) {
                            patientsProv.setSelectedRoomId(val);
                          },
                        ),
                      ),
                      IconButton(
                        tooltip: "Refrescar",
                        onPressed: () {
                          patientsProv.retryLoading();
                        },
                        icon: const Icon(Icons.refresh),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Lista de pacientes
          Expanded(
            child: Consumer<PatientsNursingLicProvider>(
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
                          MedicationKardexNursingLicView.routerName,
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
          ),
        ],
      ),
    );
  }
}
