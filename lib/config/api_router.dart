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
import 'package:tusalud/views/admin/hospital/bed/beds_admin_view.dart';
import 'package:tusalud/views/admin/hospital/hospital_admin_view.dart';
import 'package:tusalud/views/admin/hospital/rooms/room_admin_view.dart';
import 'package:tusalud/views/admin/peoples/nurses/nurses_admin_view.dart';
import 'package:tusalud/views/admin/peoples/patients/add_patients_admin_view.dart';
import 'package:tusalud/views/admin/peoples/patients/patients_admin_view.dart';
import 'package:tusalud/views/admin/peoples/people_admin.view.dart';
import 'package:tusalud/views/admin/peoples/supervisor/supervisor_admin_view.dart';
import 'package:tusalud/views/admin/settings/gender/gender_admin_view.dart';
import 'package:tusalud/views/admin/settings/settings_admin_view.dart';
import 'package:tusalud/views/app/nav_bar_view.dart';

import '../providers/auth/user_provider.dart';
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
      GoRoute(
        name: LoginView.routerName,
        path: LoginView.routerPath,
        builder: (context, state) => const LoginView(),
      ),
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return NavBarView(child: child);
        },
        routes: <RouteBase>[
          GoRoute(
            name: SplashView.routerName,
            path: SplashView.routerPath,
            builder: (context, state) => const SplashView(),
          ),

//-------------------------------------------------------------------------------------------------------------------------
// ADMIN SECTION
//-------------------------------------------------------------------------------------------------------------------------

          // HOME ADMIN
          GoRoute(
            name: HomeAdminView.routerName,
            path: HomeAdminView.routerPath,
            builder: (context, state) => const HomeAdminView(),
          ),
          // HOSPITAL ADMIN
          GoRoute(
            name: HospitalAdminView.routerName,
            path: HospitalAdminView.routerPath,
            builder: (context, state) => const HospitalAdminView(),
          ),
          // ROOMS ADMIN
          GoRoute(
            name: RoomsAdminView.routerName,
            path: RoomsAdminView.routerPath,
            builder: (context, state) => const RoomsAdminView(),
          ),
          // BEDS ADMIN
          GoRoute(
            name: BedsAdminView.routerName,
            path: BedsAdminView.routerPath,
            builder: (context, state) => const BedsAdminView(),
          ),
          // PEOPLE ADMIN
          GoRoute(
            name: PeopleAdminView.routerName,
            path: PeopleAdminView.routerPath,
            builder: (context, state) => const PeopleAdminView(),
          ),
          // NURSE ADMIN
          GoRoute(
            name: NursesAdminView.routerName,
            path: NursesAdminView.routerPath,
            builder: (context, state) => const NursesAdminView(),
          ),
          // SUPERVISOR ADMIN
          GoRoute(
            name: SupervisorsAdminView.routerName,
            path: SupervisorsAdminView.routerPath,
            builder: (context, state) => const SupervisorsAdminView(),
          ),
          // PATIENT ADMIN
          GoRoute(
            name: PatientsAdminView.routerName,
            path: PatientsAdminView.routerPath,
            builder: (context, state) => const PatientsAdminView(),
          ),
          // SETTINGS ADMIN
          GoRoute(
            name: SettingsAdminView.routerName,
            path: SettingsAdminView.routerPath,
            builder: (context, state) => const SettingsAdminView(),
          ),
          // GENDER ADMIN
          GoRoute(
            name: GenderAdminView.routerName,
            path: GenderAdminView.routerPath,
            builder: (context, state) => const GenderAdminView(),
          ),
          // ROLE ADMIN
          GoRoute(
            name: RoleAdminView.routerName,
            path: RoleAdminView.routerPath,
            builder: (context, state) => const RoleAdminView(),
          ),
          // ADD PATIENT
          GoRoute(
            name: AddPatientView.routerName,
            path: AddPatientView.routerPath,
            builder: (context, state) => const AddPatientView(),
          ),
          // ADD NURSE
          GoRoute(
            name: AddNurseAdminView.routerName,
            path: AddNurseAdminView.routerPath,
            builder: (context, state) => const AddNurseAdminView(),
          ),


//-------------------------------------------------------------------------------------------------------------------------
// NURSE SECTION
//-------------------------------------------------------------------------------------------------------------------------
          GoRoute(
            name: HomeNurseView.routerName,
            path: HomeNurseView.routerPath,
            builder: (context, state) => const HomeNurseView(),
          ),

//-------------------------------------------------------------------------------------------------------------------------
// SUPERVISOR SECTION
//-------------------------------------------------------------------------------------------------------------------------
          GoRoute(
            name: HomeSupervisorView.routerName,
            path: HomeSupervisorView.routerPath,
            builder: (context, state) => const HomeSupervisorView(),
          ),
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
  ];
}
