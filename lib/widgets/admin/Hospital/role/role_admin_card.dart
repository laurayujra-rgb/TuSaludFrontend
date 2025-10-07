import 'package:flutter/material.dart';
import 'package:tusalud/api/response/app/ts_role_response.dart';
import 'package:tusalud/style/app_style.dart';

class RoleAdminCard extends StatelessWidget {
  final TsRoleResponse role;
  final VoidCallback? onTap;

  const RoleAdminCard({
    super.key,
    required this.role,
    this.onTap,
  });

  // Color base por rol
  Color _getRoleColor() {
    switch (role.roleId) {
      case 1:
        return Colors.deepPurpleAccent; // Supervisor(a)
      case 2:
        return Colors.blueAccent;       // Enfermera
      case 3:
        return Colors.green;            // Licenciada
      case 4:
        return Colors.pinkAccent;       // Paciente
      default:
        return Colors.grey;
    }
  }

  // Nombre por rol (override si viene null)
  String _getRoleName() {
    switch (role.roleId) {
      case 1:
        return "Supervisor(a)";
      case 2:
        return "Enfermera";
      case 3:
        return "Licenciada";
      case 4:
        return "Paciente";
      default:
        return role.roleName ?? "Rol desconocido";
    }
  }

  // Icono por rol
  IconData _getRoleIcon() {
    switch (role.roleId) {
      case 1:
        return Icons.verified_user;   // Supervisor
      case 2:
        return Icons.medical_services;// Enfermera
      case 3:
        return Icons.school;          // Licenciada
      case 4:
        return Icons.person;          // Paciente
      default:
        return Icons.help_outline;
    }
  }

  // Oscurecer un color sin usar .shade*
  Color _darken(Color color, [double amount = .2]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark =
        hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  @override
  Widget build(BuildContext context) {
    final Color roleColor = _getRoleColor();
    final Color textColor = _darken(roleColor, .25); // tono un poco más oscuro

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: roleColor.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: roleColor.withOpacity(0.3), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: roleColor.withOpacity(0.1),
                blurRadius: 6,
                spreadRadius: 1,
                offset: const Offset(2, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Ícono del rol
              Container(
                decoration: BoxDecoration(
                  color: roleColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: Icon(
                  _getRoleIcon(),
                  size: 32,
                  color: roleColor,
                ),
              ),
              const SizedBox(width: 16),

              // Información principal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getRoleName(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "ID: ${role.roleId}",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              // Badge tipo toggle (solo visual)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: roleColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: roleColor.withOpacity(0.3)),
                ),
                child: Text(
                  _getRoleName().toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
