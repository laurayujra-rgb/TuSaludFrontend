import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/admin/register_user_admin_provider.dart';
import 'package:tusalud/widgets/admin/people/nurse/add_nurses_admin_card.dart';

class AddNurseAdminView extends StatelessWidget {
  static const String routerName = 'addNurseAdmin';
  static const String routerPath = '/add_nurse_admin';

  const AddNurseAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RegisterUserAdminProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Agregar Enfermera"),
        ),
        body: const SingleChildScrollView(
          child: AddNurseAdminCard(),
        ),
      ),
    );
  }
}
