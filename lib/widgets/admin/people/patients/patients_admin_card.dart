import 'package:flutter/material.dart';
import 'package:tusalud/api/response/app/ts_people_response.dart';

class PatientAdminCard extends StatelessWidget {
  final TsPeopleResponse person;

  const PatientAdminCard({super.key, required this.person});

  void _showDetails(BuildContext context) {
    final bed = person.bed;
    final room = bed?.room;
    final camaOcupada = bed?.bedOccupied == true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Avatar + nombre
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 42,
                        backgroundColor: Colors.teal.withOpacity(0.1),
                        child: const Icon(
                          Icons.person,
                          size: 46,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "${person.personName ?? ''} "
                        "${person.personFahterSurname ?? ''} "
                        "${person.personMotherSurname ?? ''}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        person.role.roleName ?? 'Paciente',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 🔹 Datos detallados
                _buildDetailRow(Icons.badge, "DNI", person.personDni ?? "-"),
                _buildDetailRow(
                    Icons.cake, "Nacimiento", person.personBirthdate ?? "-"),
                _buildDetailRow(
                    Icons.numbers, "Edad", "${person.personAge ?? '-'}"),
                _buildDetailRow(
                    Icons.wc, "Género", person.gender.genderName ?? "-"),
                _buildDetailRow(Icons.check_circle, "Estado",
                    person.personStatus == 1 ? "Activo" : "Inactivo"),

                const Divider(height: 28),

                // 🔹 Sala y cama
                _buildDetailRow(Icons.meeting_room, "Sala",
                    room?.roomName ?? "-"),
                _buildDetailRow(Icons.bed, "Cama", bed?.bedName ?? "-"),
                _buildDetailRow(
                  camaOcupada ? Icons.lock : Icons.lock_open,
                  "Estado cama",
                  camaOcupada ? "Ocupada" : "Libre",
                ),

                const SizedBox(height: 20),

                // 🔹 Cerrar
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.close, color: Colors.white),
                    label: const Text(
                      "Cerrar",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () => Navigator.of(sheetContext).pop(),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bed = person.bed;
    final room = bed?.room;
    final camaOcupada = bed?.bedOccupied == true;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

        leading: CircleAvatar(
          radius: 26,
          backgroundColor: Colors.teal.withOpacity(0.15),
          child: const Icon(Icons.person, size: 30, color: Colors.teal),
        ),

        title: Text(
          "${person.personName ?? ''} ${person.personFahterSurname ?? ''}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),

        // 👇 mostramos sala / cama / estado cama
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              person.personMotherSurname ?? '',
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 4),
            Text(
              "Sala: ${room?.roomName ?? '-'}  •  Cama: ${bed?.bedName ?? '-'}",
              style: const TextStyle(color: Colors.black54, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  camaOcupada ? Icons.lock : Icons.lock_open,
                  size: 14,
                  color: camaOcupada ? Colors.redAccent : Colors.green,
                ),
                const SizedBox(width: 6),
                Text(
                  camaOcupada ? "Cama ocupada" : "Cama libre",
                  style: TextStyle(
                    color: camaOcupada ? Colors.redAccent : Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),

        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_hospital, color: Colors.teal, size: 20),
            const SizedBox(height: 4),
            Text(
              person.role.roleName ?? '',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.teal,
              ),
            ),
          ],
        ),

        onTap: () => _showDetails(context),
      ),
    );
  }
}

Widget _buildDetailRow(IconData icon, String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Icon(icon, size: 20, color: Colors.blueGrey),
        const SizedBox(width: 10),
        Text(
          "$label: ",
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.black54),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}
