import 'package:flutter/material.dart';
import 'package:tusalud/views/nurse/patients/patientes_nurse_view.dart';
import 'package:tusalud/views/nurse/settings_nurse_view.dart';
import 'package:tusalud/views/views.dart';
import 'package:tusalud/widgets/app/custom_icon.dart';

import '../../style/app_style.dart';

class NavBarNurseView extends StatelessWidget {
  const NavBarNurseView({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppStyle.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: const Color(0xFF4CAF50).withOpacity(0.2), // verde salud
            width: 1,
          ),
        ),
        height: 72,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const [
            CustomIcon(
              icon: Icon(Icons.home, color: Color(0xFF4CAF50)), // verde esmeralda
              index: 0,
              label: 'Inicio',
              route: HomeNurseView.routerName,
            ),
            CustomIcon(
              icon: Icon(Icons.person_3_rounded, color: Color(0xFF009688)), // turquesa
              index: 1,
              label: 'Perfil',
            ),
            CustomIcon(
              icon: Icon(Icons.local_hospital_rounded, color: Color(0xFF26A69A)), // teal más suave
              index: 2,
              label: 'Pacientes',
              route: PatientsNurseView.routerName,
            ),
            CustomIcon(
              icon: Icon(Icons.settings, color: Color(0xFF00796B)), // verde azulado oscuro
              index: 3,
              label: 'Ajustes',
              route: SettingsView.routerName,
            ),

          ],
        ),
      ),
    );
  }
}
