import 'package:flutter/material.dart';
import 'package:tusalud/api/response/app/ts_people_response.dart';

class NurseAdminCard extends StatelessWidget {
  final TsPeopleResponse person;

  const NurseAdminCard({super.key, required this.person});

  void _showDetails(BuildContext context) {
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
                // 🔹 Avatar y nombre
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        child: Icon(Icons.person, size: 40),
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
                      const SizedBox(height: 8),
                      Text(
                        person.role.roleName ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 🔹 Datos en lista con íconos
                _buildDetailRow(Icons.badge, "DNI", person.personDni ?? "-"),
                _buildDetailRow(Icons.cake, "Nacimiento", person.personBirthdate ?? "-"),
                _buildDetailRow(Icons.numbers, "Edad", "${person.personAge ?? '-'}"),
                _buildDetailRow(Icons.wc, "Género", person.gender.genderName ?? "-"),
                _buildDetailRow(
                  Icons.check_circle,
                  "Estado",
                  person.personStatus == 1 ? "Activo" : "Inactivo",
                ),

                const SizedBox(height: 20),

                // 🔹 Botón cerrar
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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: const CircleAvatar(
          radius: 24,
          child: Icon(Icons.person, size: 28),
        ),
        title: Text(
          "${person.personName ?? ''} ${person.personFahterSurname ?? ''}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(person.personMotherSurname ?? ''),
        trailing: Text(
          person.role.roleName ?? '',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.blueAccent,
          ),
        ),
        onTap: () => _showDetails(context),
      ),
    );
  }
}

/// 🔹 Helper para mostrar fila de detalle
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
