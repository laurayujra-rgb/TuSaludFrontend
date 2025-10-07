import 'package:flutter/material.dart';
import 'package:tusalud/views/admin/hospital/hospital_admin_view.dart';
import 'package:tusalud/views/admin/peoples/people_admin.view.dart';
import 'package:tusalud/views/admin/settings/settings_admin_view.dart';
import 'package:tusalud/views/admin/profile/prifle_admin_view.dart';
import 'package:tusalud/views/views.dart';
import 'package:tusalud/widgets/app/custom_icon.dart';

import '../../style/app_style.dart';

class NavBarAdminView extends StatelessWidget {
  const NavBarAdminView({super.key, required this.child});
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
              route: HomeAdminView.routerName,
            ),
            CustomIcon(
              icon: Icon(Icons.person_3_rounded, color: Colors.redAccent), // logout en rojo
              index: 1,
              label: 'Perfil',
              route: ProfileAdminView.routerName,
            ),
            // CustomIcon(
            //   icon: Icon(Icons.local_hospital_rounded, color: Color(0xFF26A69A)), // teal más suave
            //   index: 2,
            //   label: 'Hospital',
            //   route: HospitalAdminView.routerName,
            // ),
            CustomIcon(
              icon: Icon(Icons.person_add_alt_1_rounded, color: Color(0xFF43A047)), // verde oscuro
              index: 2,
              label: 'Personal',
              route: PeopleAdminView.routerName,
            ),

            CustomIcon(
              icon: Icon(Icons.local_hospital, color: Color(0xFF388E3C)), // verde medio
              index: 3,
              label: 'Hospital',
              route: SettingsAdminView.routerName,
            ),
            CustomIcon(
              icon: Icon(Icons.logout, color: Colors.redAccent), // logout en rojo
              index: 4,
              label: 'Salir',
              route: LoginView.routerName,
            ),

          ],
        ),
      ),
    );
  }
}
