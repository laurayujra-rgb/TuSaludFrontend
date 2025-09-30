import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/views/nurse/add_vital_signs_nurse_view.dart';
import 'package:tusalud/widgets/nurse/vital_signs_nurse_card.dart';
import '../../providers/nurse/vital_signs_provider.dart';

class VitalSignsNurseView extends StatefulWidget {
  static const String routerName = 'vitalSignsNurse';
  static const String routerPath = '/vital_signs_nurse';

  final int kardexId;
  final String? headerSubtitle; // opcional (ej: nombre paciente o #kardex)

  const VitalSignsNurseView({
    super.key,
    required this.kardexId,
    this.headerSubtitle,
  });

  @override
  State<VitalSignsNurseView> createState() => _VitalSignsNurseViewState();
}

class _VitalSignsNurseViewState extends State<VitalSignsNurseView> {
  @override
  void initState() {
    super.initState();
    // cargar signos vitales desde el provider
    Future.microtask(() =>
        Provider.of<VitalSignsNurseProvider>(context, listen: false)
            .loadVitalSignsByKardex(widget.kardexId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.background,
      appBar: AppBar(
        backgroundColor: AppStyle.card,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppStyle.textDark),
        title: Column(
          children: [
            const Text(
              "Signos Vitales",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppStyle.textDark,
                letterSpacing: 0.3,
              ),
            ),
            if (widget.headerSubtitle != null)
              Text(
                widget.headerSubtitle!,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppStyle.textLight,
                ),
              ),
          ],
        ),
      ),
      body: Consumer<VitalSignsNurseProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading == true) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage != null) {
            return Center(
              child: Text(
                provider.errorMessage!,
                style: const TextStyle(color: AppStyle.danger),
              ),
            );
          }

          // filtrar por kardexId
          final vitalSigns = provider.allVitalSigns
              .where((vs) => vs.kardexId == widget.kardexId)
              .toList();

          if (vitalSigns.isEmpty) {
            return const Center(
              child: Text(
                "No hay signos vitales registrados para este Kardex",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppStyle.textLight,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 12, bottom: 80),
            itemCount: vitalSigns.length,
            itemBuilder: (context, index) {
              final item = vitalSigns[index];
              return VitalSignsNurseCard(vitalSign: item);
            },
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppStyle.accent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddVitalSignNurseView(kardexId: widget.kardexId),
                ),
              );

              if (result == true) {
                // refrescar lista después de guardar
                Provider.of<VitalSignsNurseProvider>(context, listen: false)
                    .loadVitalSignsByKardex(widget.kardexId);
              }
            },

          icon: const Icon(Icons.add),
          label: const Text(
            "Agregar Signo Vital",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
