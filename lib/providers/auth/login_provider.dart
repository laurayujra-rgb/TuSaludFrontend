import 'package:flutter/material.dart';
import 'package:tusalud/api/request/auth/ts_auth_request.dart';
import 'package:tusalud/utils/utils.dart';

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
  
}