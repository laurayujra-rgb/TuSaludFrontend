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
            Text(
              "${patient.personName ?? ''} "
              "${patient.personFahterSurname ?? ''} "
              "${patient.personMotherSurname ?? ''}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppStyle.primary,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.badge, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text("Edad: ${patient.personAge ?? '-'}"),
                const SizedBox(width: 16),
                const Icon(Icons.transgender, size: 18, color: Colors.grey),
                const SizedBox(width: 6),
                Text(patient.gender.genderName ?? '-'),
              ],
            ),
            const SizedBox(height: 14),
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
                    side: BorderSide(color: AppStyle.primary, width: 1.5),
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
