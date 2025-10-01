import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/api/request/app/ts_reports_request.dart';
import 'package:tusalud/providers/nurse/reports_nurse_provider.dart';
import 'package:tusalud/widgets/nurse/reports/add_reports_nurse_card.dart';

class AddReportsNurseView extends StatefulWidget {
  static const String routerName = 'addReportsNurse';
  static const String routerPath = '/add_reports_nurse';

  final int kardexId;

  const AddReportsNurseView({super.key, required this.kardexId});

  @override
  State<AddReportsNurseView> createState() => _AddReportsNurseViewState();
}

class _AddReportsNurseViewState extends State<AddReportsNurseView> {
  final _formKey = GlobalKey<FormState>();
  final _reportDetailsController = TextEditingController();

  @override
  void dispose() {
    _reportDetailsController.dispose();
    super.dispose();
  }

  Future<void> _saveReport() async {
    if (!_formKey.currentState!.validate()) return;

    final request = TsReportsRequest(
      reportDetails: _reportDetailsController.text.trim(),
      kardexId: widget.kardexId,
    );

    await Provider.of<ReportsNurseProvider>(context, listen: false)
        .addReport(request);

    if (mounted) {
      Navigator.pop(context, true); // notifica éxito al volver
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReportsNurseProvider>(context);

    return Scaffold(
      backgroundColor: AppStyle.background,
      appBar: AppBar(
        title: const Text("Agregar Reporte"),
        backgroundColor: AppStyle.card,
        iconTheme: const IconThemeData(color: AppStyle.textDark),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: AddReportsNurseCard(
            reportDetailsController: _reportDetailsController,
          ),
        ),
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
          onPressed: provider.isAdding == true ? null : _saveReport,
          icon: provider.isAdding == true
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Icon(Icons.save),
          label: Text(
            provider.isAdding == true ? "Guardando..." : "Guardar Reporte",
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
