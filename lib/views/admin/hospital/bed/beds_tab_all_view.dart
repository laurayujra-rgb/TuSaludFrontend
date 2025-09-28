import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tusalud/providers/admin/beds_admin_provider.dart';
import 'package:tusalud/widgets/admin/beds/bed_admin_card.dart';

class BedsTabAllView extends StatefulWidget {
  const BedsTabAllView({super.key});

  @override
  State<BedsTabAllView> createState() => _BedsTabAllViewState();
}

class _BedsTabAllViewState extends State<BedsTabAllView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<BedsAdminProvider>(context, listen: false).loadAllBeds());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BedsAdminProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading == true) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.allBeds.isEmpty) {
          return const Center(child: Text("No hay camas registradas"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: provider.allBeds.length,
          itemBuilder: (context, index) {
            final bed = provider.allBeds[index];
            return BedAdminCard(bed: bed);
          },
        );
      },
    );
  }
}
