import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/app/profile_provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/widgets/app/custom_app_bar.dart';
import 'package:tusalud/widgets/nursing%20Lic/profile/profile_nurse_lic_card.dart';

import '../../../generated/l10.dart';
class ProfileNurseLicView extends StatelessWidget {
  static const String routerName = 'profileNurse';
  static const String routerPath = '/profileNurse';

  const ProfileNurseLicView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileProvider()..loadCurrentUserData(),
      child: Scaffold(
        backgroundColor: AppStyle.backgroundModern,
        appBar: CustomAppBar(
          centerTitle: true,
          text: S.of(context).profile,
          backgroundColor: AppStyle.backgroundModern,
        ),
        body: const _ProfileContent(),
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: const [
          _TopBackgroundWave(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: ProfileNurseLicCard(),
          ),
        ],
      ),
    );
  }
}

class _TopBackgroundWave extends StatelessWidget {
  const _TopBackgroundWave();

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WaveClipper(),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppStyle.primary,
              AppStyle.primary.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);

    final firstControlPoint = Offset(size.width / 4, size.height);
    final firstEndPoint = Offset(size.width / 2, size.height - 30);
    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

    final secondControlPoint =
        Offset(size.width - (size.width / 4), size.height - 70);
    final secondEndPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(
        secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
