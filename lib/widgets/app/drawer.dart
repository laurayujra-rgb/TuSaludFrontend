import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/generated/l10.dart';
import 'package:tusalud/providers/app/drawer_provider.dart';
import 'package:tusalud/providers/auth/user_provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/utils/assets_image.dart';

import '../../utils/logout_util.dart';

class TuSaludDrawer extends StatelessWidget{
  const TuSaludDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    final DrawerProvider drawerProvider = Provider.of<DrawerProvider>(context);
    return Drawer(
      backgroundColor: AppStyle.white,
      surfaceTintColor: AppStyle.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            DrawerHeader(
              child: Column(
              children: [
                AssetsImages.logoAvatar(height: 70),
                const SizedBox(height: 8),
                Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    return Column(
                      children: [
                        Text(
                          '${userProvider.name ?? ''} ${userProvider.lastName ?? ''}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${(userProvider.role ?? '').replaceFirst('ROLE_', '')} ${userProvider.personId ?? ''}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),

                      ],
                    );
                  },
                ),
              ],
              )
            ),
            // DrawerListTile(icon: Icons.home, onTap: () => drawerProvider.goToHomeAdmin(context), title: S.of(context).home),
            // DrawerListTile(icon: Icons.account_circle_rounded, onTap: () => drawerProvider.goToProfile(context), title: S.of(context).profile),
            // DrawerListTile(icon: Icons.car_repair_rounded, onTap: () => drawerProvider.goToVehiclesAdmin(context), title: S.of(context).vehicles),
            // DrawerListTile(icon: Icons.car_repair_rounded, onTap: () => drawerProvider.goToVehicleTypeAdmin(context), title: S.of(context).vehicleType),
            // DrawerListTile(icon: Icons.badge_rounded, onTap: () => drawerProvider.goToBrandsAdmin(context), title: S.of(context).brand),
            // DrawerListTile(icon: Icons.oil_barrel_sharp, onTap: ()=> drawerProvider.goToFuelTypeAdmin(context), title: S.of(context).fuel),
            // DrawerListTile(icon: Icons.color_lens_rounded, onTap: () => drawerProvider.goToVehiclesColorsAdmin(context), title: S.of(context).color),
            // DrawerListTile(icon: Icons.public, onTap: () => drawerProvider.goToCountriesAdmin(context), title: S.of(context).country),
            // DrawerListTile(icon: Icons.location_on_rounded, onTap: () => drawerProvider.goToRoadTypeAdmin(context), title: S.of(context).roadType),
            // DrawerListTile(icon: Icons.supervised_user_circle_rounded, onTap: () => drawerProvider.goToPersonAdmin(context), title: S.of(context).staff),
            // DrawerListTile(icon: Icons.business_outlined, onTap: () => drawerProvider.goToTollAdmin(context), title: S.of(context).tolls),
            // DrawerListTile(icon: Icons.people, onTap: () => drawerProvider.goToGenderAdmin(context), title: S.of(context).gender),
            // DrawerListTile(icon: Icons.people_outline_sharp, onTap: () => drawerProvider.goToPersonTypeAdmin(context), title: S.of(context).personType),
            // DrawerListTile(icon: Icons.auto_graph_rounded, onTap: () {}, title: S.of(context).reports),
            // const Spacer(),
            DrawerListTile(icon: Icons.logout_rounded,onTap: () => showLogoutConfirmation(context),title: S.of(context).logout,
),

          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.icon,
    required this.onTap,
    required this.title
  });
  final IconData icon;
  final Function() onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: Icon(
          icon,
          color: AppStyle.primary,
          size: 30,
        ),
        title: Text(title, style: const TextStyle(color: AppStyle.primary, fontSize: 18, fontWeight: FontWeight.w600),),
      ),
    );
  }
}