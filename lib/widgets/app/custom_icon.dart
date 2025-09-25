import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/app/home_provider.dart';

import '../../style/app_style.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon({
    super.key,
    required this.icon,
    required this.index,
    required this.label,
    this.route,
    this.onTap,
  });

  final Widget icon;
  final int index;
  final String label;
  final String? route;         // ✅ ahora opcional
  final VoidCallback? onTap;   // ✅ nuevo parámetro opcional

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!(); // Ejecuta acción personalizada (logout, etc.)
        } else if (route != null) {
          homeProvider.changeNavBar(context, index, route!); // Navegación estándar
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: homeProvider.currentIndex == index
              ? AppStyle.primary.withOpacity(0.3)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
        padding: const EdgeInsets.all(6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            Text(
              label,
              style: const TextStyle(
                color: AppStyle.primary,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
