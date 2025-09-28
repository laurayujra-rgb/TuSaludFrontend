import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tusalud/providers/auth/user_provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/widgets/app/drawer.dart';
import 'package:tusalud/widgets/nurse/home_nurse_dasboard.dart';

import '../../widgets/admin/home_admin_dashboard.dart';

class HomeNurseView extends StatelessWidget{
  static const String routerName = 'nurseHome';
  static const String routerPath = '/nurseHome';
  const HomeNurseView({Key? key}) : super (key: key);
    
    @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppStyle.primary.withOpacity(0.1),
                  border: Border.all(color: AppStyle.primary, width: 2),
                ),
                child: const Icon(
                  Icons.verified_user,
                  size: 30,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(width: 12),
              Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${userProvider.name ?? ''}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${userProvider.lastName ?? ''}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        backgroundColor: AppStyle.ligthGrey,
        body: isMobile
            ? const SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: HomeNurseDashBoard(),
                ),
              )
            : const Row(
                children: [
                  TuSaludDrawer(),
                  Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: HomeNurseDashBoard(),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
  
   
}