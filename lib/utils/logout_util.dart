import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth/login_provider.dart';

Future<void> showLogoutConfirmation(BuildContext context) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Cerrar sesión'),
      content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Cerrar sesión'),
        ),
      ],
    ),
  );

  if (confirm == true) {
    Provider.of<LoginProvider>(context, listen: false).logout(context);
  }
}
