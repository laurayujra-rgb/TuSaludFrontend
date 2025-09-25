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
    "registrationSuccessful": MessageLookupByLibrary.simpleMessage("Registro exitoso"),
    "name": MessageLookupByLibrary.simpleMessage("Nombre"),
    "pleaseEnterName": MessageLookupByLibrary.simpleMessage("Por favor ingrese su nombre"),
    "surname": MessageLookupByLibrary.simpleMessage("Apellido"),
    "pleaseEnterSurname": MessageLookupByLibrary.simpleMessage("Por favor ingrese su apellido"),
    "birthdate": MessageLookupByLibrary.simpleMessage("Fecha de nacimiento"),
    "pleaseSelectBirthdate": MessageLookupByLibrary.simpleMessage("Por favor ingrese su fecha de nacimiento"),
    
    "whatsappNumber": MessageLookupByLibrary.simpleMessage("Número de WhatsApp"),     
    "pleaseEnterWhatsappNumber": MessageLookupByLibrary.simpleMessage("Por favor ingrese su número de WhatsApp"),
    "pleaseEnterEmail": MessageLookupByLibrary.simpleMessage("Por favor ingrese su correo electrónico"),
    "pleaseEnterValidEmail": MessageLookupByLibrary.simpleMessage("Por favor ingrese un correo electrónico válido"),
    "pleaseEnterPassword": MessageLookupByLibrary.simpleMessage("Por favor ingrese su contraseña"),
    "passwordTooShort": MessageLookupByLibrary.simpleMessage("La contraseña es demasiado corta"),
    "confirmPassword": MessageLookupByLibrary.simpleMessage("Confirmar contraseña"),
    "pleaseConfirmPassword": MessageLookupByLibrary.simpleMessage("Por favor confirme su contraseña"),  
    "dni": MessageLookupByLibrary.simpleMessage("DNI"),
    "pleaseEnterDni": MessageLookupByLibrary.simpleMessage("Por favor ingrese su DNI"),
    "address": MessageLookupByLibrary.simpleMessage("Dirección"),
    "pleaseEnterAddress": MessageLookupByLibrary.simpleMessage("Por favor ingrese su dirección"),
    "age": MessageLookupByLibrary.simpleMessage("Edad"),
    "pleaseEnterAge": MessageLookupByLibrary.simpleMessage("Por favor ingrese su edad"),
    "pleaseEnterValidAge": MessageLookupByLibrary.simpleMessage("Por favor ingrese una edad válida"),
    "gender": MessageLookupByLibrary.simpleMessage("Género"),
    "pleaseSelectGender": MessageLookupByLibrary.simpleMessage("Por favor seleccione su género"),
    "role": MessageLookupByLibrary.simpleMessage("Rol"),
    "pleaseSelectRole": MessageLookupByLibrary.simpleMessage("Por favor seleccione su rol"),
    "register": MessageLookupByLibrary.simpleMessage("Registrar"),
    "welcomeMessage": MessageLookupByLibrary.simpleMessage("¡Bienvenido a TuSalud!"),
    "logout": MessageLookupByLibrary.simpleMessage("Cerrar sesión"),
    "selectRole": MessageLookupByLibrary.simpleMessage("Seleccionar rol"),
    "selectYourRole": MessageLookupByLibrary.simpleMessage("Seleccione su rol"),
    "administration": MessageLookupByLibrary.simpleMessage("Administración"),
    "nurse": MessageLookupByLibrary.simpleMessage("Enfermera"),
    "supervisor": MessageLookupByLibrary.simpleMessage("Supervisor"),
  };
  
  
  }