import 'package:flutter/material.dart';
import 'package:tusalud/views/views.dart';
import 'package:tusalud/widgets/app/custom_icon.dart';

import '../../style/app_style.dart';

class NavBarView extends StatelessWidget {
  const NavBarView({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppStyle.white,
          boxShadow: [
            BoxShadow(
              color: AppStyle.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        height: 72,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const CustomIcon(icon: Icon(Icons.home, color: AppStyle.primary), index: 0, label: 'Inicio', route: HomeAdminView.routerName),
//             CustomIcon(icon: Icon(Icons.account_circle_rounded, color: AppStyle.primary), index: 1, label: S.of(context).profile, route: ProfileCustomerView.routerName),
//             CustomIcon(icon: Icon(Icons.car_crash_outlined, color: AppStyle.primary), index: 3, label: S.of(context).vehicle, route: VehiclesCustomerView.routerName),
//             CustomIcon(icon: Icon(Icons.wallet_outlined, color: AppStyle.primary), index: 4, label: S.of(context).wallet, route: WalletView.routerName),
//             // logout button
//             CustomIcon(icon: const Icon(Icons.logout, color: AppStyle.primary), index: 5,label: S.of(context).logout,onTap: () => showLogoutConfirmation(context),),

          
          ],
        ),
      ),
    );
  }
}