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
import 'package:tusalud/views/app/select_mode_view.dart';
import 'package:tusalud/widgets/app/loading.dart';

import '../../config/api_router.dart';
import '../../views/supervisor/home_supervisor_view.dart';
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

void goHome(BuildContext context) async {
  if (validateForm()) {
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

      if (response.isSuccess() && response.data != null) {
        final token = response.data!;
        final data = TuSaludApi().parseJwt(token.accessToken ?? '');

        // Guardar tokens y datos
        await Preferences().setAccessToken(token.accessToken ?? '');
        await Preferences().setRefreshToken(token.refreshToken ?? '');
        await Preferences().setEmail(data['email'] ?? '');
        await Preferences().setLastName(data['lastName'] ?? '');
        await Preferences().setName(data['name'] ?? '');
        await Preferences().setRole(data['roles']?[0] ?? '');
        await Preferences().setPersonId(data['personId'] ?? 0);

        final role = data['roles']?[0] ?? '';

        // 🔹 Usa el contexto raíz del GoRouter
        final rootContext = rootNavigatorKey.currentContext!;
        final userProvider = Provider.of<UserProvider>(rootContext, listen: false);

        userProvider.setUserData(
          data['name'] ?? '',
          data['lastName'] ?? '',
          role,
          data['email'] ?? '',
          data['personId'] ?? 0,
        );

        if (!rootContext.mounted) return;

        // 🔹 Verifica el tipo de dispositivo
        final isMobile = ResponsiveBreakpoints.of(rootContext).smallerThan(TABLET);
        if (!isMobile) {
          _showErrorDialog(
            rootContext,
            'Acceso bloqueado',
            'Esta aplicación solo puede ser utilizada desde un teléfono móvil.',
          );
          return;
        }

        // 🔹 Todos los roles acceden desde móvil
        await OrientationUtil.setPortraitOnly();

        if (role == 'ROLE_SUPERVISORA') {
          rootContext.goNamed(HomeAdminView.routerName);
        } else if (role == 'ROLE_ENFERMERA') {
          rootContext.goNamed(HomeNurseView.routerName);
        } else if (role == 'ROLE_LICENCIADA') {
          rootContext.goNamed(HomeNursingLicView.routerName);
        } else {
          rootContext.goNamed(LoginView.routerName);
        }

      } else if (response.isUnauthorized()) {
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