import 'package:flutter/material.dart';
import 'package:tusalud/api/response/app/ts_people_response.dart';

class PatientAdminCard extends StatelessWidget {
  final TsPeopleResponse person;

  const PatientAdminCard({super.key, required this.person});

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
                // 🔹 Avatar grande + nombre
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
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

        // 🔹 Icono de avatar de paciente
        leading: CircleAvatar(
          radius: 26,
          backgroundColor: Colors.teal.withOpacity(0.15),
          child: const Icon(Icons.person, size: 30, color: Colors.teal),
        ),

        // 🔹 Nombre y apellidos
        title: Text(
          "${person.personName ?? ''} ${person.personFahterSurname ?? ''}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),

        // 🔹 Apellido materno debajo
        subtitle: Text(
          person.personMotherSurname ?? '',
          style: const TextStyle(color: Colors.black54),
        ),

        // 🔹 Rol a la derecha
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

/// 🔹 Helper para fila de detalle en el modal
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
