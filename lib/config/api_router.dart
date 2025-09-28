import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tusalud/providers/admin/beds_admin_provider.dart';
import 'package:tusalud/providers/admin/rooms_admin_provider.dart';
import 'package:tusalud/providers/app/home_provider.dart';
import 'package:tusalud/providers/app/select_mdoe_provider.dart';
import 'package:tusalud/providers/auth/login_provider.dart';
import 'package:tusalud/providers/auth/sign_up_provider.dart';
import 'package:tusalud/providers/auth/splashView.dart';
import 'package:tusalud/views/admin/hospital/bed/beds_admin_view.dart';
import 'package:tusalud/views/admin/hospital/hospital_admin_view.dart';
import 'package:tusalud/views/admin/hospital/rooms/room_admin_view.dart';
import 'package:tusalud/views/admin/peoples/people_admin.view.dart';
import 'package:tusalud/views/app/nav_bar_view.dart';


import '../providers/auth/user_provider.dart';
import '../views/views.dart';

final GlobalKey<NavigatorState>rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState>shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');
final GlobalKey<NavigatorState>adminNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'admin');

class AppRouter{
  static final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: kDebugMode,
    routes:[
      GoRoute(
        name: LoginView.routerName,
        path: LoginView.routerPath,
        builder: (context, state) => const LoginView(),
      ),
      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child){
        return NavBarView(child: child);
        },
        navigatorKey: shellNavigatorKey,
        routes: <RouteBase>[
          GoRoute(
            name: SplashView.routerName,
            path: SplashView.routerPath,
            builder: (context, state) => const SplashView(),
          ),
          GoRoute(
//-------------------------------------------------------------------------------------------------------------------------
// ADMIN SECTION
// ------------------------------------------------------------------------------------------------------------------------

          // HOME ADMIN
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
//-------------------------------------------------------------------------------------------------------------------------
// NURSE SECTION
// ------------------------------------------------------------------------------------------------------------------------
          GoRoute(
            name: HomeNurseView.routerName,
            path: HomeNurseView.routerPath,
            builder: (context, state) => const HomeNurseView(),
          ),
//-------------------------------------------------------------------------------------------------------------------------
// SUPERVISOR SECTION
// ------------------------------------------------------------------------------------------------------------------------
          GoRoute(
            name: HomeSupervisorView.routerName,
            path: HomeSupervisorView.routerPath,
            builder: (context, state) => const HomeSupervisorView(),
          )
        ]
      )
    ]

  );
        static final List<SingleChildWidget> providers = [
          ChangeNotifierProvider(create: (_) => SelectModeProvider()),
          ChangeNotifierProvider(create: (_) => LoginProvider()),
          ChangeNotifierProvider(create: (_) => SignUpProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => HomeProvider()),
          ChangeNotifierProvider(create: (_) => BedsAdminProvider()),
          ChangeNotifierProvider(create: (_) => RoomsAdminProvider()),
          // ----------------------------------------------------------
        
          
          
        ];
        
}