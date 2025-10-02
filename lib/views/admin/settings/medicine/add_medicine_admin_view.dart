import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/admin/medicine_nurse_provider.dart';
import 'package:tusalud/providers/admin/via_admin_provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/widgets/admin/settings/medicine/add_medicine_admin_card.dart';
import 'package:tusalud/api/request/app/ts_medication_request.dart';
import 'package:tusalud/api/response/app/ts_via_response.dart';

class AddMedicineAdminView extends StatelessWidget {
  static const String routerName = 'addMedicineAdmin';
  static const String routerPath = '/add_medicine_admin';

  const AddMedicineAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ViaAdminProvider()..loadVias()),
      ],
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true, // 👈 Ajusta al aparecer el teclado
          backgroundColor: AppStyle.ligthGrey,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 1,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: AppStyle.primary),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              "Registrar Medicamento",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                letterSpacing: 0.5,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView( // 👈 Hace scroll si se tapa con el teclado
              padding: const EdgeInsets.all(16),
              child: AddMedicineAdminCard(
                onSubmit: (String name, String lab, TsViaResponse via) async {
                  final req = TsMedicineRequest(
                    medicineName: name,
                    medicineLaboratory: lab,
                    viaId: via.viaId,
                  );

                  final provider = context.read<MedicineNurseProvider>();
                  final success = await provider.createMedicine(req);

                  if (success) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("✅ Medicamento creado correctamente"),
                        ),
                      );
                      Navigator.pop(context);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("❌ Error: ${provider.errorMessage}"),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
