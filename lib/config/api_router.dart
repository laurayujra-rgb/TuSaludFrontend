import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:tusalud/providers/auth/login_provider.dart';
import 'package:tusalud/views/admin/home_admin_view.dart';
import 'package:tusalud/views/app/nav_bar_view.dart';
import 'package:tusalud/views/auth/login_view.dart';

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
            name: HomeAdminView.routerName,
            path: HomeAdminView.routerPath,
            builder: (context, state) => const HomeAdminView(),
          )
        ]
      )
    ]

  );
        static final List<SingleChildWidget> providers = [
          ChangeNotifierProvider(create: (_) => LoginProvider()),
          
        ];
        
}