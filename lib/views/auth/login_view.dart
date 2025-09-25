import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tusalud/providers/auth/login_provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/utils/assets_image.dart';
import 'package:tusalud/utils/validators.dart';
import 'package:tusalud/views/auth/signup_view.dart';
import 'package:tusalud/widgets/app/custom_field.dart';
import '../../generated/l10.dart';
import '../../widgets/app/custom_button.dart';
class LoginView extends StatelessWidget{
  static const String routerName = 'login';
  static const String routerPath = '/login';
  const LoginView({super.key});
  @override
  Widget build(BuildContext context){
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(isMobile) const LoginMobileView(),
                // if(!isMobile) const LoginTabletView()
              ],
            ),
          ),
        )
      ),
    );
  }
}
class LoginMobileView extends StatelessWidget{
  const LoginMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 80),
        AssetsImages.map(height: 100, width: 100),
        AssetsImages.logo(height: 100, width: 200),
        const SizedBox(height: 20),
        const LoginForm()
      ],
    );    
  }
}
class LoginForm extends StatefulWidget{
  const LoginForm({super.key});
  @override
  State<LoginForm> createState() => _LoginFormState();
}
class _LoginFormState extends State<LoginForm> {
  bool _obscureLoginPassword = true;
  @override
  Widget build(BuildContext context) {
    final LoginProvider loginProvider = Provider.of<LoginProvider>(context);
    return Form(
      key: loginProvider.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            S.of(context).loginToYourAccount,
            style: const TextStyle(
              color: AppStyle.primary,
              fontSize: 20, 
              fontWeight: FontWeight.bold
            ),
          ),
          const SizedBox(height: 32),
          CustomField(
            hintText: S.of(context).email,
            keyboardType: TextInputType.emailAddress,
            onChanged: (value) => loginProvider.request.personEmail = value,
            prefixIcon: const Icon(Icons.email),
            validator: (value) {
              if(value.isEmpty) {
                return 'El correo electronico es requerido';
              }
              if(!isValidEmail.hasMatch(value)){
                return 'El correo electronico es invalido';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              hintText: S.of(context).password,
              prefixIcon: const Icon(Icons.lock),
              
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureLoginPassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureLoginPassword = !_obscureLoginPassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: AppStyle.primary),
                
              ),
            ),
            keyboardType: TextInputType.visiblePassword,
            obscureText: _obscureLoginPassword,
            onChanged: (value) => loginProvider.request.personPassword = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'La contraseña es requerida';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),
          CustomButton(
            onPressed: () => loginProvider.goHome(context), 
            text: S.of(context).login,
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => context.go(SignUpView.routerPath),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: S.of(context).dontHaveAnAccount,
                    style: const TextStyle(
                      color: AppStyle.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  TextSpan(
                    text: S.of(context).signUp,
                    style: const TextStyle(
                      color: AppStyle.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
                style: const TextStyle(
                  color: AppStyle.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}