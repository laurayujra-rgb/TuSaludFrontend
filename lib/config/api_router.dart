import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/single_child_widget.dart';

final GlobalKey<NavigatorState>rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState>shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');
final GlobalKey<NavigatorState>adminNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'admin');

class AppRouter{
  static final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: kDebugMode,
    routes:[
      // GoRoute(
        
      // ),
      // ShellRoute(
      //   builder: (BuildContext context, GoRouterState state, Widget child){
          
      //   }
      // )
    ]

  );
        static final List<SingleChildWidget> providers = [];
}