import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/admin/diet_admin_provider.dart';
import 'package:tusalud/providers/nursing%20Lic/kardex_nursing_lic_provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/widgets/nursing%20Lic/kardex/edit_kardex_nursing_lic_card.dart';
import 'package:tusalud/api/response/app/ts_kardex_response.dart';

class EditKardexNursingLicView extends StatelessWidget {
  static const String routerName = 'editKardexNursingLic';
  static const String routerPath = '/edit_kardex_nursing_lic';

  final TsKardexResponse kardex;
  final int patientId;

  const EditKardexNursingLicView({
    super.key,
    required this.kardex,
    required this.patientId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DietAdminProvider()),
      ],
      child: Scaffold(
        backgroundColor: AppStyle.ligthGrey,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppStyle.primary, Colors.indigoAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.edit_document, size: 36, color: Colors.white),
                      SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          "Editar Kardex",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                EditKardexNursingLicCard(
                  kardex: kardex,
                  patientId: patientId,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
