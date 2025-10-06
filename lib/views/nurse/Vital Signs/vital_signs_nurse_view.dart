import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/views/nurse/Vital%20Signs/add_vital_signs_nurse_view.dart';
import 'package:tusalud/widgets/nurse/vital%20signs/vital_signs_nurse_card.dart';
import 'package:tusalud/providers/nurse/vital_signs_provider.dart';

class VitalSignsNurseView extends StatefulWidget {
  static const String routerName = 'vitalSignsNurse';
  static const String routerPath = '/vital_signs_nurse';

  final int kardexId;
  final String? headerSubtitle;

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
    Future.microtask(() =>
        Provider.of<VitalSignsNurseProvider>(context, listen: false)
            .loadVitalSignsByKardex(widget.kardexId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.background,
      appBar: AppBar(
        backgroundColor: AppStyle.primary,
        elevation: 2,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Column(
          children: [
            const Text(
              "Signos Vitales",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            if (widget.headerSubtitle != null)
              Text(
                widget.headerSubtitle!,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.white70,
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

          return RefreshIndicator(
            onRefresh: () async {
              await provider.loadVitalSignsByKardex(widget.kardexId);
            },
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 16, bottom: 90),
              itemCount: vitalSigns.length,
              itemBuilder: (context, index) {
                final item = vitalSigns[index];
                return VitalSignsNurseCard(vitalSign: item);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppStyle.accent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Nuevo registro",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddVitalSignNurseView(kardexId: widget.kardexId),
            ),
          );

          if (result == true) {
            Provider.of<VitalSignsNurseProvider>(context, listen: false)
                .loadVitalSignsByKardex(widget.kardexId);
          }
        },
      ),
    );
  }
}
