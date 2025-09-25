import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tusalud/providers/auth/user_provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/widgets/app/custom_app_bar.dart';
import 'package:tusalud/widgets/app/drawer.dart';

class HospitalAdminView extends StatelessWidget{
  static const String routerName = 'hospitalAdmin';
  static const String routerPath = '/hospitalAdmin';

  const HospitalAdminView({Key? key}) ;

  @override
  Widget build(BuildContext context){
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return SafeArea(
      child: Scaffold(
      backgroundColor: AppStyle.white,
      body: isMobile
          ? const SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  HospitalAdminList(),
                ],
              ),
            ),
          )
          :const HospitalAdminTabletView(),
      ),
    );
  }
}

class HospitalAdminTabletView extends StatelessWidget {
  const HospitalAdminTabletView({super.key});

  @override
  Widget build(BuildContext context){
    return const Row(
      children: [
        TuSaludDrawer(),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  HospitalAdminList(),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class HospitalAdminList extends StatefulWidget{
  const HospitalAdminList({super.key});

  @override
  State<HospitalAdminList> createState() => _HospitalAdminListState();
}
class _HospitalAdminListState extends State<HospitalAdminList>{
  @override
  void initState(){
    super.initState();
    _loadRooms();
    _loadBeds();
  }

  void _loadRooms() {
    // TODO: Implement room loading logic
    WidgetsBinding.instance.addPostFrameCallback((_){
      final provider = Provider.of<RoomsAdminProvider>(context, listen: false);



    });
  }

  void _loadBeds() {
    // TODO: Implement bed loading logic
  }
}