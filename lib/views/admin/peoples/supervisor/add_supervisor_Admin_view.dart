import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/admin/gender_provider.dart';
import 'package:tusalud/providers/admin/register_user_admin_provider.dart';
import 'package:tusalud/widgets/admin/people/supervisor/add_supervisor_admin_card.dart';

class AddSupervisorAdminView extends StatelessWidget {
  static const String routerName = 'addSupervisorAdmin';
  static const String routerPath = '/add_supervisor_admin';

  const AddSupervisorAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterUserAdminProvider()),
        ChangeNotifierProvider(create: (_) => GenderAdminProvider()..loadGenders()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Nueva Supervisora"),
          centerTitle: true,
        ),
        body: const SingleChildScrollView(
          child: AddSupervisorAdminCard(),
        ),
      ),
    );
  }
}
