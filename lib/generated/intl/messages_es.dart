import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();
typedef String MessageIfAbsent(String messageStr, List<dynamic> args);
class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'es';
  
    final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    
    "loginToYourAccount": MessageLookupByLibrary.simpleMessage("Iniciar sesión en su cuenta"),
    "email": MessageLookupByLibrary.simpleMessage("Correo electrónico"),
    "password": MessageLookupByLibrary.simpleMessage("Contraseña"),
    "login": MessageLookupByLibrary.simpleMessage("Iniciar sesión"),
    "signUp": MessageLookupByLibrary.simpleMessage("Regístrate"),
    "dontHaveAnAccount": MessageLookupByLibrary.simpleMessage("¿No tienes una cuenta?"),
  };
  
  
  }