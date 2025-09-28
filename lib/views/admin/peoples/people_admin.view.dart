import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tusalud/widgets/app/drawer.dart';
import '../../../style/app_style.dart';

class PeopleAdminView extends StatelessWidget {
  static const String routerName = 'peopleAdmin';
  static const String routerPath = '/people_admin';

  const PeopleAdminView({Key? key}) : super(key: key);

  void _navigate(BuildContext context, String route) {
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        backgroundColor: AppStyle.ligthGrey,
        body: isMobile
            ? _buildContent(context)
            : Row(
                children: [
                  const TuSaludDrawer(),
                  Expanded(
                    flex: 2,
                    child: _buildContent(context),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 🔹 Encabezado como tarjeta (ya no título del AppBar)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: AppStyle.primary.withOpacity(0.2)),
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
                      Icons.groups,
                      size: 36,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      "Gestión de Personas",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 🔹 Opciones
            _buildOptionCard(
              context,
              title: "Gestión de Enfermeras",
              icon: Icons.local_hospital,
              color: Colors.pinkAccent,
              route: "/nurses_admin",
            ),
            const SizedBox(height: 16),
            _buildOptionCard(
              context,
              title: "Gestión de Pacientes",
              icon: Icons.person,
              color: Colors.teal,
              route: "/patients_admin",
            ),
            const SizedBox(height: 16),
            _buildOptionCard(
              context,
              title: "Gestión de Supervisoras",
              icon: Icons.supervisor_account,
              color: Colors.deepPurple,
              route: "/supervisors_admin",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    return InkWell(
      onTap: () => _navigate(context, route),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: AppStyle.primary.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, size: 30, color: color),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
