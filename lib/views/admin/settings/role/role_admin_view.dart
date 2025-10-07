import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/admin/role_provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/widgets/admin/Hospital/role/role_admin_card.dart';

class RoleAdminView extends StatefulWidget {
  static const String routerName = 'role_admin';
  static const String routerPath = '/role_admin';

  const RoleAdminView({super.key});

  @override
  State<RoleAdminView> createState() => _RoleAdminViewState();
}

class _RoleAdminViewState extends State<RoleAdminView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<RoleAdminProvider>(context, listen: false).loadRoles());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.ligthGrey,
      body: Column(
        children: [
          // HEADER sin flecha atrás ni botón agregar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 40, 16, 8),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppStyle.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppStyle.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const Icon(
                      Icons.admin_panel_settings,
                      size: 36,
                      color: AppStyle.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Administración de Roles",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Consulta los roles predefinidos del sistema",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // LISTADO DE ROLES (solo lectura)
          Expanded(
            child: Consumer<RoleAdminProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.roles.isEmpty) {
                  return const Center(child: Text("No hay roles registrados"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: provider.roles.length,
                  itemBuilder: (context, index) {
                    final role = provider.roles[index];
                    return RoleAdminCard(
                      role: role,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Rol: ${role.roleName} — ID: ${role.roleId}"),
                            duration: const Duration(seconds: 2),
                          ),
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
