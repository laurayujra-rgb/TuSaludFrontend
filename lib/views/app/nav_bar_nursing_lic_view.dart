
import 'package:flutter/material.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/views/auth/login_view.dart';
import 'package:tusalud/views/nursing%20Lic/home/home_nursing_lic_view.dart';
import 'package:tusalud/views/nursing%20Lic/patient/patients_nursing_lic_view.dart';
import 'package:tusalud/views/nursing%20Lic/profile/profile_nurse_lic_view.dart';
import 'package:tusalud/widgets/app/custom_icon.dart';

class NavBarNursingLicView extends StatelessWidget {
  const NavBarNursingLicView({super.key, required this.child});
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
              route: HomeNursingLicView.routerName,
            ),
            CustomIcon(
              icon: Icon(Icons.person_3_rounded, color: Colors.redAccent), // logout en rojo
              index: 1,
              label: 'Perfil',
              route: ProfileNurseLicView.routerName,
            ),
            CustomIcon(
              icon: Icon(Icons.local_hospital_rounded, color: Color(0xFF26A69A)), // teal más suave
              index: 2,
              label: 'Pacientes',
              route: PatientsNursingLicView.routerName,
            ),
            // CustomIcon(
            //   icon: Icon(Icons.person_add_alt_1_rounded, color: Color(0xFF43A047)), // verde oscuro
            //   index: 3,
            //   label: 'Personal',
            //   route: PeopleAdminView.routerName,
            // ),
            // CustomIcon(
            //   icon: Icon(Icons.assignment_add, color: Color(0xFF00796B)), // verde profundo
            //   index: 4,
            //   label: 'Asignar',
            // ),

            // CustomIcon(
            //   icon: Icon(Icons.settings, color: Color(0xFF388E3C)), // verde medio
            //   index: 5,
            //   label: 'Ajustes',
            //   route: SettingsAdminView.routerName,
            // ),
            CustomIcon(
              icon: Icon(Icons.logout, color: Colors.redAccent), // logout en rojo
              index: 3,
              label: 'Salir',
              route: LoginView.routerName,
            ),

          ],
        ),
      ),
    );
  }
}
