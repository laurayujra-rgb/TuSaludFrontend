import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tusalud/api/request/auth/ts_auth_request.dart';
import 'package:tusalud/api/tu_salud_api.dart';
import 'package:tusalud/config/preferences.dart';
import 'package:tusalud/providers/auth/user_provider.dart';
import 'package:tusalud/utils/orientation_util.dart';
import 'package:tusalud/utils/utils.dart';
import 'package:tusalud/views/auth/login_view.dart';
import 'package:tusalud/widgets/app/loading.dart';

import '../../views/views.dart';

class LoginProvider extends ChangeNotifier{
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TsAuthRequest request = TsAuthRequest.createEmpty();
  void _showErrorDialog(BuildContext context, String title, String content){
    if(context.mounted){
      Utils.dialogOption(
      content: content,
      context: context,
      iconData: Icons.close,
      title: title,
      width: MediaQuery.of(context).size.width * 0.6
      );
    }
  }

void goHome(BuildContext context) async{
      if(validateForm()){
    OverlayLoadingProgress.start(
      context,
      widget: const Loading(
        title: "Iniciando sesión",
        message: "Por favor espere...",
      ),
    );
    
    try {
      final response = await TuSaludApi().autenticateUser(request);
      OverlayLoadingProgress.stop();
      
      if(response.isSuccess() && response.data != null){
        final token = response.data!; // Ya es del tipo StTokenRequest
        final data = TuSaludApi().parseJwt(token.accessToken ?? '');
        
        // Guardar tokens y datos de usuario
        Preferences().setAccessToken(token.accessToken ?? '');
        Preferences().setRefreshToken(token.refreshToken ?? '');
        Preferences().setEmail(data['email'] ?? '');
        Preferences().setLastName(data['lastName'] ?? '');
        Preferences().setName(data['name'] ?? '');
        Preferences().setRole(data['roles']?[0] ?? ''); // Ajuste para el campo roles
        Preferences().setPersonId(data['personId'] ?? 0); // Si es null, guarda 0
        // En tu LoginProvider
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final role = data['roles']?[0] ?? '';
        userProvider.setUserData(
          data['name'] ?? '',
          data['lastName'] ?? '',
          role,
          data['email'] ?? '',
          data['personId'] ?? 0 

        );
        // Redirección basada en el rol
          if (context.mounted) {
            final isTablet = ResponsiveBreakpoints.of(context).largerThan(MOBILE);
            final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);

            if (role == 'ROLE_ADMINISTRADOR') {
              if (isMobile) {
                _showErrorDialog(
                  context,
                  'Acceso denegado',
                  'Los administradores solo pueden iniciar sesión desde una tablet o PC.'
                );
                return;
              }
              await OrientationUtil.setAllowAll();
              context.goNamed(HomeAdminView.routerName);

            } else if (role == 'ROLE_CLIENTE') {
              if (isTablet) {
                _showErrorDialog(
                  context,
                  'Acceso denegado',
                  'Los clientes solo pueden iniciar sesión desde un dispositivo móvil.'
                );
                return;
              }
              await OrientationUtil.setPortraitOnly();
              context.goNamed(HomeNurseView.routerName);

            } else if (role == 'ROLE_OPERADOR') {
              if (isMobile) {
                _showErrorDialog(
                  context,
                  'Acceso denegado',
                  'Los operadores solo pueden iniciar sesión desde una tablet o PC.'
                );
                return;
              }
              await OrientationUtil.setAllowAll();
              context.goNamed(HomeSupervisorView.routerName);
            }
          }

      } else if(response.isUnauthorized()){
        _showErrorDialog(context, 'Credenciales incorrectas', 
          'Por favor verifica tus credenciales e intenta nuevamente');
      } else {
        _showErrorDialog(context, 'Error', 
          response.message ?? 'Ha ocurrido un error inesperado');
      }
    } catch (e) {
      OverlayLoadingProgress.stop();
      _showErrorDialog(context, 'Error', 
        'Excepción durante el login: ${e.toString()}');
    }
  }
}

    void goToSelectMode(BuildContext context){
    context.goNamed(SelectModeView.routerName);
  }

  void login(BuildContext context) {
    context.pushNamed(LoginView.routerName);
  }

  void signup(BuildContext context) {
    context.pushNamed(SignUpView.routerName);
  }

  bool validateForm() {
    final isValid = formKey.currentState?.validate() ?? false;
    notifyListeners();
    return isValid;
  }

    // logout
  void logout(BuildContext context) async {
  await Preferences().clearSession();

  // Limpia también el estado del userProvider
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  userProvider.setUserData('', '', '', '', 0); // Valores vacíos

  if (context.mounted) {
    context.goNamed(LoginView.routerName); // Redirige al login
  }
}

}