import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/auth/user_provider.dart';

import '../../generated/l10.dart';
import '../../style/app_style.dart';


class HomeSupervisorDashBoard extends StatelessWidget {
  
  const HomeSupervisorDashBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    // final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    // final vehiclesProvider = Provider.of<VehiclesCustomerProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final personId = userProvider.personId;
      if (personId != null) {
        // vehiclesProvider.loadCustomerVehicles(personId);
        // walletProvider.loadUserVehicles();
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppStyle.white, width: 1),
            borderRadius: BorderRadius.circular(8),
            color: AppStyle.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
            child: Text(
              S.of(context).welcomeMessage,
              style: const TextStyle(
                color: AppStyle.primary,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
class HomeCard extends StatelessWidget {
  const HomeCard({
    super.key,
    required this.data,
    required this.icon,
    required this.title,
    this.subtitle = '',
  });

  final String data;
  final Widget icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppStyle.white, width: 1),
        borderRadius: BorderRadius.circular(8),
        color: AppStyle.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    data,
                    style: const TextStyle(
                      color: AppStyle.primary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
