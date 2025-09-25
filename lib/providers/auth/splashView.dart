import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/config/preferences.dart';

import '../../views/views.dart';
import 'user_provider.dart';

class SplashView extends StatefulWidget {
  static const String routerName = 'splash';
  static const String routerPath = '/';
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final token = await Preferences().accessToken();
    final role = await Preferences().role();
    final name = await Preferences().name();
    final lastName = await Preferences().lastName();
    final email = await Preferences().email();
    final personId = await Preferences().personId();

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (token.isNotEmpty) {
      userProvider.setUserData(name, lastName, role, email, personId);

      if (!mounted) return;
      if (role == 'ROLE_ADMINISTRADOR') {
        // context.goNamed(ProfileView.routerName);
      } else if (role == 'ROLE_ENFERMERA') {
        // context.goNamed(HomeView.routerName);
      } else if (role == 'ROLE_SUPERVISOR') {
        // context.goNamed(HomeOperadorView.routerName);
      } else {
        // context.goNamed(LoginView.routerName);
      }
    } else {
      if (mounted) {
        // context.goNamed(LoginView.routerName);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
