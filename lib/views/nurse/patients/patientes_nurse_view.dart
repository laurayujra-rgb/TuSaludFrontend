import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/api/tu_salud_api.dart';
import 'package:tusalud/providers/nurse/patients_nurse_provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/views/nurse/Reports/reports_nurse_view.dart';
import 'package:tusalud/views/nurse/Vital%20Signs/vital_signs_nurse_view.dart';
import '../../../widgets/nurse/patients/patients_nurse_card.dart';
import 'package:go_router/go_router.dart';

// 👇 nuevo
import 'package:tusalud/providers/admin/rooms_admin_provider.dart';

class PatientsNurseView extends StatefulWidget {
  static const String routerName = 'patientsNurse';
  static const String routerPath = '/patients_nurse';

  final String? headerSubtitle;

  const PatientsNurseView({super.key, this.headerSubtitle});

  @override
  State<PatientsNurseView> createState() => _PatientsNurseViewState();
}

class _PatientsNurseViewState extends State<PatientsNurseView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<PatientsNurseProvider>(context, listen: false).loadPatients();
      // 👇 cargar salas para el filtro
      Provider.of<RoomsAdminProvider>(context, listen: false).loadRooms();
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
          // 🔹 Filtro por sala (igual que en Lic)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Consumer2<PatientsNurseProvider, RoomsAdminProvider>(
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

          // 🔹 Lista de pacientes
          Expanded(
            child: Consumer<PatientsNurseProvider>(
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
                      onVitalSigns: () async {
                        final response = await TuSaludApi().getKardexByPatientId(patient.personId);

                        if (response.dataList != null && response.dataList!.isNotEmpty) {
                          final kardex = response.dataList!.last;
                          context.pushNamed(
                            VitalSignsNurseView.routerName,
                            queryParameters: {
                              'kardexId': kardex.kardexId.toString(),
                              'headerSubtitle':
                                  "Paciente: ${patient.personName} ${patient.personFahterSurname ?? ''}",
                            },
                          );
                        } else {
                          context.pushNamed(
                            VitalSignsNurseView.routerName,
                            queryParameters: {
                              'kardexId': '0',
                              'headerSubtitle':
                                  "Paciente: ${patient.personName} ${patient.personFahterSurname ?? ''}",
                            },
                          );
                        }
                      },
                      onReports: () async {
                        final response = await TuSaludApi().getKardexByPatientId(patient.personId);

                        if (response.dataList != null && response.dataList!.isNotEmpty) {
                          final kardex = response.dataList!.last;
                          context.pushNamed(
                            ReportsNurseView.routerName,
                            queryParameters: {
                              'kardexId': kardex.kardexId.toString(),
                              'headerSubtitle':
                                  "Paciente: ${patient.personName} ${patient.personFahterSurname ?? ''}",
                            },
                          );
                        } else {
                          context.pushNamed(
                            ReportsNurseView.routerName,
                            queryParameters: {
                              'kardexId': '0',
                              'headerSubtitle':
                                  "Paciente: ${patient.personName} ${patient.personFahterSurname ?? ''}",
                            },
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
    );
  }
}
