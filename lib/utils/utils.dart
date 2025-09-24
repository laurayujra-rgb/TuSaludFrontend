import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/widgets/app/custom_dialog.dart';


class Utils{
  static textFieldAlert({required BuildContext context, required Widget content, required String negativeText, Function()? positiveOnPressed, required String positiveText, required String title, Function()? negativeOnPressed}){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppStyle.white,
          contentPadding: const EdgeInsets.all(16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))
          ),
          surfaceTintColor: Colors.transparent,
          title: Text(title),
          content: content,
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppStyle.white,
                elevation: 0,
                foregroundColor: AppStyle.primary,
                shadowColor: AppStyle.primary,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))
                ),
                surfaceTintColor: Colors.transparent,
              ),
              onPressed: negativeOnPressed ?? () {
                context.pop();
              },
              child: Text(
                negativeText, 
                style: const TextStyle(
                  color: AppStyle.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppStyle.white,
                elevation: 0,
                foregroundColor: AppStyle.primary,
                shadowColor: AppStyle.primary,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))
                ),
                surfaceTintColor: Colors.transparent,
              ),
              onPressed: positiveOnPressed,
              child: Text(
                positiveText, 
                style: const TextStyle(
                  color: AppStyle.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Future<void> dialogOption({
    required BuildContext context,
    required String title,
    required String content,
    IconData? iconData,
    String? onActionText,
    String? onActionTextNegative,
    bool? barrierDismissible,
    Function? onAction,
    Function? onActionNegative,
    double? width,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible ?? true,
      builder: (context) {
        return CustomDialogPermission(
          title: title,
          content: content,
          iconData: iconData,
          positiveBtnText: onActionText ?? "Ok",
          negativeBtnText: onActionTextNegative ?? "Volver",
          positiveBtnPressed: onAction == null ? null: () async { onAction(); },
          negativeBtnPressed: onActionNegative == null ? null : () async { onActionNegative(); },
          width: width,
        );
      }
    );
  }
}