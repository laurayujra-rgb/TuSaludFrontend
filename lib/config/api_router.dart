
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tusalud/providers/admin/beds_admin_provider.dart';
import 'package:tusalud/providers/admin/gender_provider.dart';
import 'package:tusalud/providers/admin/people_admin_provider.dart';
import 'package:tusalud/providers/admin/register_user_admin_provider.dart';
import 'package:tusalud/providers/admin/role_provider.dart';
import 'package:tusalud/providers/admin/rooms_admin_provider.dart';
import 'package:tusalud/providers/app/home_provider.dart';
import 'package:tusalud/providers/app/select_mdoe_provider.dart';
import 'package:tusalud/providers/auth/login_provider.dart';
import 'package:tusalud/providers/auth/registe_user_provider.dart';
import 'package:tusalud/providers/auth/splashView.dart';
import 'package:tusalud/providers/admin/diet_admin_provider.dart';
import 'package:tusalud/providers/admin/medicine_nurse_provider.dart';
import 'package:tusalud/providers/nurse/patients_nurse_provider.dart';
import 'package:tusalud/providers/nurse/reports_nurse_provider.dart';
import 'package:tusalud/providers/admin/via_admin_provider.dart';
import 'package:tusalud/providers/nurse/vital_signs_provider.dart';
import 'package:tusalud/providers/nursing%20Lic/patients_nursing_lic_provider.dart';
import 'package:tusalud/views/admin/hospital/bed/add_beds_admin_view.dart';
import 'package:tusalud/views/admin/hospital/bed/beds_admin_view.dart';
import 'package:tusalud/views/admin/hospital/hospital_admin_view.dart';
import 'package:tusalud/views/admin/hospital/rooms/room_admin_view.dart';
import 'package:tusalud/views/admin/peoples/nurses/nurses_admin_view.dart';
import 'package:tusalud/views/admin/peoples/patients/add_patients_admin_view.dart';
import 'package:tusalud/views/admin/peoples/patients/patients_admin_view.dart';
import 'package:tusalud/views/admin/peoples/people_admin.view.dart';
import 'package:tusalud/views/admin/peoples/supervisor/supervisor_admin_view.dart';
import 'package:tusalud/views/admin/settings/diet/add_diet_admin_view.dart';
import 'package:tusalud/views/admin/settings/gender/gender_admin_view.dart';
import 'package:tusalud/views/admin/settings/medicine/add_medicine_admin_view.dart';
import 'package:tusalud/views/admin/settings/settings_admin_view.dart';
import 'package:tusalud/views/admin/settings/via%20Medicine/add_via_admin_view.dart';
import 'package:tusalud/views/app/nav_bar_admin_view.dart';
import 'package:tusalud/views/app/nav_bar_nurse_view.dart';
import 'package:tusalud/views/app/nav_bar_nursing_lic_view.dart';
import 'package:tusalud/views/nursing%20Lic/kardex/add_kardex_nursing_lic_view.dart';
import 'package:tusalud/views/nurse/Reports/add_reports_nurse_view.dart';
import 'package:tusalud/views/nurse/Vital%20Signs/add_vital_signs_nurse_view.dart';
import 'package:tusalud/views/admin/settings/diet/diet_admin_view.dart';
import 'package:tusalud/views/nursing%20Lic/kardex/kardex_nursing_lic_view.dart';
import 'package:tusalud/views/admin/settings/medicine/medicine_nursing_lic_view.dart';
import 'package:tusalud/views/nurse/patients/patientes_nurse_view.dart';
import 'package:tusalud/views/nurse/Reports/reports_nurse_view.dart';
import 'package:tusalud/views/nurse/settings_nurse_view.dart';
import 'package:tusalud/views/nursing%20Lic/patient/patients_nursing_lic_view.dart';
import 'package:tusalud/views/admin/settings/via%20Medicine/via_admin_view.dart';
import 'package:tusalud/views/nurse/Vital%20Signs/vital_signs_nurse_view.dart';

import '../providers/auth/user_provider.dart';
import '../providers/nursing Lic/kardex_nursing_lic_provider.dart';
import '../views/admin/peoples/nurses/add_nurse_admin_view.dart';
import '../views/admin/settings/role/role_admin_view.dart';

import '../views/views.dart';

final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');
final GlobalKey<NavigatorState> adminNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'admin');

class AppRouter {
  static final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: kDebugMode,
    routes: [
      // LOGIN / SPLASH fuera de ShellRoute
      GoRoute(
        name: LoginView.routerName,
        path: LoginView.routerPath,
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        name: SplashView.routerName,
        path: SplashView.routerPath,
        builder: (context, state) => const SplashView(),
      ),

      //-------------------------------------------------------------------
      // ADMIN SECTION   - SUPERVISOR
      //-------------------------------------------------------------------
      ShellRoute(
        builder: (context, state, child) {
          return NavBarAdminView(child: child);
        },
        routes: [
          GoRoute(
            name: HomeAdminView.routerName,
            path: HomeAdminView.routerPath,
            builder: (context, state) => const HomeAdminView(),
          ),
          GoRoute(
            name: HospitalAdminView.routerName,
            path: HospitalAdminView.routerPath,
            builder: (context, state) => const HospitalAdminView(),
          ),
          GoRoute(
            name: RoomsAdminView.routerName,
            path: RoomsAdminView.routerPath,
            builder: (context, state) => const RoomsAdminView(),
          ),
          GoRoute(
            name: BedsAdminView.routerName,
            path: BedsAdminView.routerPath,
            builder: (context, state) => const BedsAdminView(),
          ),
          GoRoute(
            name: PeopleAdminView.routerName,
            path: PeopleAdminView.routerPath,
            builder: (context, state) => const PeopleAdminView(),
          ),
          GoRoute(
            name: NursesAdminView.routerName,
            path: NursesAdminView.routerPath,
            builder: (context, state) => const NursesAdminView(),
          ),
          GoRoute(
            name: SupervisorsAdminView.routerName,
            path: SupervisorsAdminView.routerPath,
            builder: (context, state) => const SupervisorsAdminView(),
          ),
          GoRoute(
            name: PatientsAdminView.routerName,
            path: PatientsAdminView.routerPath,
            builder: (context, state) => const PatientsAdminView(),
          ),
          GoRoute(
            name: SettingsAdminView.routerName,
            path: SettingsAdminView.routerPath,
            builder: (context, state) => const SettingsAdminView(),
          ),
          GoRoute(
            name: GenderAdminView.routerName,
            path: GenderAdminView.routerPath,
            builder: (context, state) => const GenderAdminView(),
          ),
          GoRoute(
            name: RoleAdminView.routerName,
            path: RoleAdminView.routerPath,
            builder: (context, state) => const RoleAdminView(),
          ),
          GoRoute(
            name: AddPatientView.routerName,
            path: AddPatientView.routerPath,
            builder: (context, state) => const AddPatientView(),
          ),
          GoRoute(
            name: AddNurseAdminView.routerName,
            path: AddNurseAdminView.routerPath,
            builder: (context, state) => const AddNurseAdminView(),
          ),
          GoRoute(
            name: ViasView.routerName,
            path: ViasView.routerPath,
            builder: (context, state) => const ViasView(),
          ),
          GoRoute(
            name: AddViaAdminView.routerName,
            path: AddViaAdminView.routerPath,
            builder: (context, state) => const AddViaAdminView(),
          ),
          GoRoute(
            name: DietAdminView.routerName,
            path: DietAdminView.routerPath,
            builder: (context, state) => const DietAdminView(),
          ),
          GoRoute(
            name: AddDietAdminView.routerName,
            path: AddDietAdminView.routerPath,
            builder: (context, state) => const AddDietAdminView(),
          ),
          GoRoute(
            name: MedicineNurseView.routerName,
            path: MedicineNurseView.routerPath,
            builder: (context, state) => const MedicineNurseView(),
          ),
          GoRoute(
            name: AddMedicineAdminView.routerName,
            path: AddMedicineAdminView.routerPath,
            builder: (context, state) => const AddMedicineAdminView(),
          ),
          GoRoute(
            name: AddBedAdminView.routerName,
            path: AddBedAdminView.routerPath,
            builder: (context, state) => const AddBedAdminView(),
          )
        ],
      ),

      //-------------------------------------------------------------------
      // NURSE SECTION
      //-------------------------------------------------------------------
      ShellRoute(
        builder: (context, state, child) {
          return NavBarNurseView(child: child);
        },
        routes: [
          GoRoute(
            name: HomeNurseView.routerName,
            path: HomeNurseView.routerPath,
            builder: (context, state) => const HomeNurseView(),
          ),
          GoRoute(
            name: PatientsNurseView.routerName,
            path: PatientsNurseView.routerPath,
            builder: (context, state) =>  const PatientsNurseView(),
            ),
          // GoRoute(
          //   name: SettingsView.routerName,
          //   path: SettingsView.routerPath,
          //   builder: (context, state) => const SettingsView(),
          // ),


          GoRoute(
            name: VitalSignsNurseView.routerName,
            path: VitalSignsNurseView.routerPath,
            builder: (context, state) {
              final kardexId = int.tryParse(state.uri.queryParameters['kardexId'] ?? '');
              final headerSubtitle = state.uri.queryParameters['headerSubtitle'];

              if (kardexId == null) {
                return const Scaffold(
                  body: Center(child: Text('Error: kardexId es requerido')),
                );
              }

              return VitalSignsNurseView(
                kardexId: kardexId,
                headerSubtitle: headerSubtitle,
              );
            },
          ),
          GoRoute(
            name: AddVitalSignNurseView.routerName,
            path: AddVitalSignNurseView.routerPath,
            builder: (context, state) {
              final kardexId = int.tryParse(state.uri.queryParameters['kardexId'] ?? '');

              if (kardexId == null) {
                return const Scaffold(
                  body: Center(child: Text('Error: kardexId es requerido')),
                );
              }

              return AddVitalSignNurseView(kardexId: kardexId);
            },
          ),
          GoRoute(
            name: ReportsNurseView.routerName,
            path: ReportsNurseView.routerPath,
            builder: (context, state) {
              final kardexId = int.tryParse(state.uri.queryParameters['kardexId'] ?? '');
              final headerSubtitle = state.uri.queryParameters['headerSubtitle'];

              if (kardexId == null) {
                return const Scaffold(
                  body: Center(child: Text('Error: kardexId es requerido')),
                );
              }

              return ReportsNurseView(
                kardexId: kardexId,
                headerSubtitle: headerSubtitle,
              );
            },
          ),
          GoRoute(
              name: AddReportsNurseView.routerName,
              path: AddReportsNurseView.routerPath,
              builder: (context, state) {
                final kardexId = int.tryParse(state.uri.queryParameters['kardexId'] ?? '');

                if (kardexId == null) {
                  return const Scaffold(
                    body: Center(child: Text('Error: kardexId es requerido')),
                  );
                }

                return AddReportsNurseView(kardexId: kardexId);
              },
            ),



        ],
      ),

      //-------------------------------------------------------------------
      // LICENCIADA SECTION
      //-------------------------------------------------------------------
      ShellRoute(
        builder: (context, state, child) {
          return NavBarNursingLicView(child: child);
        },
        routes: [
          GoRoute(
            name: HomeNursingLicView.routerName,
            path: HomeNursingLicView.routerPath,
            builder: (context, state) => const HomeNursingLicView(),
          ),
          GoRoute(
            name: PatientsNursingLicView.routerName,
            path: PatientsNursingLicView.routerPath,
            builder: (context, state) => const PatientsNursingLicView(),
          ),

          GoRoute(
            name: KardexNursingLicView.routerName,
            path: KardexNursingLicView.routerPath,
            builder: (context, state) {
              final patientId = int.tryParse(state.uri.queryParameters['patientId'] ?? '');
              final headerSubtitle = state.uri.queryParameters['headerSubtitle'];

              if (patientId == null) {
                return const Scaffold(
                  body: Center(child: Text('Error: patientId es requerido')),
                );
              }

              return KardexNursingLicView(
                patientId: patientId,
                headerSubtitle: headerSubtitle,
              );
            },
          ),

              GoRoute(
                name: AddKardexNursingLicView.routerName,
                path: AddKardexNursingLicView.routerPath,
                builder: (context, state) {
                  final patientId = int.tryParse(state.uri.queryParameters['patientId'] ?? '0') ?? 0;

                  return AddKardexNursingLicView(
                    patientId: patientId,
                  );
                },
              ),

          // aquí también podrías meter más rutas de supervisor
        ],
      ),
    ],
  );

  static final List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => SelectModeProvider()),
    ChangeNotifierProvider(create: (_) => LoginProvider()),
    ChangeNotifierProvider(create: (_) => RegisterUserProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => HomeProvider()),
    ChangeNotifierProvider(create: (_) => BedsAdminProvider()),
    ChangeNotifierProvider(create: (_) => RoomsAdminProvider()),
    ChangeNotifierProvider(create: (_) => GenderAdminProvider()),
    ChangeNotifierProvider(create: (_) => RoleAdminProvider()),
    ChangeNotifierProvider(create: (_) => PeopleAdminProvider()),
    ChangeNotifierProvider(create: (_) => RegisterUserProvider()),
    ChangeNotifierProvider(create: (_) => RegisterUserAdminProvider()),
    ChangeNotifierProvider(create: (_) => PatientsNurseProvider()),
    ChangeNotifierProvider(create: (_) => ViaAdminProvider()),
    ChangeNotifierProvider(create: (_) => DietAdminProvider()),
    ChangeNotifierProvider(create: (_) => MedicineNurseProvider()),
    ChangeNotifierProvider(create: (_) => KardexNursingLicProvider()),
    ChangeNotifierProvider(create: (_) => VitalSignsNurseProvider()),
    ChangeNotifierProvider(create: (_) => ReportsNurseProvider()),
    ChangeNotifierProvider(create: (_) => PatientsNursingLicProvider())
  ];
}
