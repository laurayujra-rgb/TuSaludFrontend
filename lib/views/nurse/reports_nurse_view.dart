import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/providers/nurse/reports_nurse_provider.dart';
import 'package:tusalud/views/nurse/add_reports_nurse_view.dart';
import 'package:tusalud/widgets/nurse/reports_nurse_card.dart';

class ReportsNurseView extends StatefulWidget {
  static const String routerName = 'reportsNurse';
  static const String routerPath = '/reports_nurse';

  final int kardexId;
  final String? headerSubtitle;

  const ReportsNurseView({
    super.key,
    required this.kardexId,
    this.headerSubtitle,
  });

  @override
  State<ReportsNurseView> createState() => _ReportsNurseViewState();
}

class _ReportsNurseViewState extends State<ReportsNurseView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<ReportsNurseProvider>(context, listen: false)
            .loadReportsByKardex(widget.kardexId));
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
              "Reportes de Enfermería",
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
      body: Consumer<ReportsNurseProvider>(
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

          final reports = provider.allReports;

          if (reports.isEmpty) {
            return const Center(
              child: Text(
                "No hay reportes registrados para este Kardex",
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
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final item = reports[index];
              return ReportNurseCard(report: item);
            },
          );
        },
      ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: AppStyle.accent,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              "Agregar Reporte",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddReportsNurseView(kardexId: widget.kardexId),
                ),
              );

              if (result == true) {
                // 🔄 refrescar la lista de reportes después de guardar
                if (mounted) {
                  Provider.of<ReportsNurseProvider>(context, listen: false)
                      .loadReportsByKardex(widget.kardexId);
                }
              }
            },
          ),

    );
  }
}
