// patients_nursing_lic_card.dart
import 'package:flutter/material.dart';
import 'package:tusalud/api/response/app/ts_people_response.dart';
import 'package:tusalud/style/app_style.dart';

class PatientsNursingLicCard extends StatelessWidget {
  final TsPeopleResponse patient;
  final VoidCallback onKardex;
  final VoidCallback onMedication;

  const PatientsNursingLicCard({
    super.key,
    required this.patient,
    required this.onKardex,
    required this.onMedication,
  });

  @override
  Widget build(BuildContext context) {
    final roomName = patient.room?.roomName ?? patient.bed?.room.roomName ?? '-';
    final bedName  = patient.bed?.bedName ?? '-';
    final gender   = patient.gender.genderName ?? '-';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nombre
            Text(
              "${patient.personName ?? ''} "
              "${patient.personFahterSurname ?? ''} "
              "${patient.personMotherSurname ?? ''}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppStyle.primary,
              ),
            ),

            const SizedBox(height: 8),

            // Fila: Edad | Género  (cada lado toma 50% y el texto se corta con ellipsis)
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.badge, size: 18, color: Colors.grey),
                      const SizedBox(width: 6),
                      const Text("Edad: "),
                      Expanded(
                        child: Text(
                          "${patient.personAge ?? '-'}",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.transgender, size: 18, color: Colors.grey),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          gender,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            // Fila: Sala | Cama (igual: 50% / 50% + ellipsis)
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.meeting_room, size: 18, color: Colors.grey),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "Sala: $roomName",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.bed, size: 18, color: Colors.grey),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "Cama: $bedName",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Botones
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppStyle.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: onKardex,
                  icon: const Icon(Icons.assignment, size: 18),
                  label: const Text("Kardex"),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppStyle.primary,
                    side: const BorderSide(color: AppStyle.primary, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: onMedication,
                  icon: const Icon(Icons.medical_services_outlined, size: 18),
                  label: const Text("Medicación"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
