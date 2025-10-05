import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tusalud/generated/intl/messages_all.dart';

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Login to your account`
  String get loginToYourAccount {
    return Intl.message(
      'Login to your account',
      name: 'loginToYourAccount',
      desc: '',
      args: [],
    );
  }
  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }
  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }
  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }
  /// `Sign Up`
  String get signUp {
    return Intl.message(
      'Sign Up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }
  /// `Don't have an account?`
  String get dontHaveAnAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dontHaveAnAccount',
      desc: '',
      args: [],
    );
  }
  /// `Passwords don't match`
  String get passwordsDontMatch {
    return Intl.message(
      'Passwords don\'t match',
      name: 'passwordsDontMatch',
      desc: '',
      args: [],
    );
  }
  /// `Registration successful`
  String get registrationSuccessful {
    return Intl.message(
      'Registration successful',
      name: 'registrationSuccessful',
      desc: '',
      args: [],
    );
  }
  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }
  /// `Please enter name`
  String get pleaseEnterName {
    return Intl.message(
      'Please enter name',
      name: 'pleaseEnterName',
      desc: '',
      args: [],
    );
  }
  /// `Surname`
  String get surname {
    return Intl.message(
      'Surname',
      name: 'surname',
      desc: '',
      args: [],
    );
  }
  /// `Please enter surname`
  String get pleaseEnterSurname {
    return Intl.message(
      'Please enter surname',
      name: 'pleaseEnterSurname',
      desc: '',
      args: [],
    );
  }
  /// `Birthdate`
  String get birthdate {
    return Intl.message(
      'Birthdate',
      name: 'birthdate',
      desc: '',
      args: [],
    );
  }
  /// `Please enter birthdate`
  String get pleaseSelectBirthdate {
    return Intl.message(
      'Please enter birthdate',
      name: 'pleaseSelectBirthdate',
      desc: '',
      args: [],
    );
  }
  /// `WhatsApp Number`
  String get whatsappNumber {
    return Intl.message(
      'WhatsApp Number',
      name: 'whatsappNumber',
      desc: '',
      args: [],
    );
  }
  /// `Please enter WhatsApp number`
  String get pleaseEnterWhatsappNumber {
    return Intl.message(
      'Please enter WhatsApp number',
      name: 'pleaseEnterWhatsappNumber',
      desc: '',
      args: [],
    );
  }
  /// `Please enter email`
  String get pleaseEnterEmail {
    return Intl.message(
      'Please enter email',
      name: 'pleaseEnterEmail',
      desc: '',
      args: [],
    );
  }
  /// `Please enter valid email`
  String get pleaseEnterValidEmail {
    return Intl.message(
      'Please enter valid email',
      name: 'pleaseEnterValidEmail',
      desc: '',
      args: [],
    );
}
/// 'pleaseEnterPassword'
  String get pleaseEnterPassword {
    return Intl.message(
      'Please enter password',
      name: 'pleaseEnterPassword',
      desc: '',
      args: [],
    );
  }
/// 'passwordTooShort'
  String get passwordTooShort {
    return Intl.message(
      'Password too short',
      name: 'passwordTooShort',
      desc: '',
      args: [],
    );
  }
/// 'confirmPassword'
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    ); 
  }
/// 'pleaseConfirmPassword'
  String get pleaseConfirmPassword {
    return Intl.message(
      'Please confirm password',
      name: 'pleaseConfirmPassword',
      desc: '',
      args: [],
    );
  }
  /// `DNI`
  String get dni {
    return Intl.message(
      'DNI',
      name: 'dni',
      desc: '',
      args: [],
    );
  }
  /// `Please enter DNI`
  String get pleaseEnterDni {
    return Intl.message(
      'Please enter DNI',
      name: 'pleaseEnterDni',
      desc: '',
      args: [],
    );
  }
  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }
  /// `Please enter address`
  String get pleaseEnterAddress {
    return Intl.message(
      'Please enter address',
      name: 'pleaseEnterAddress',
      desc: '',
      args: [],
    );
  }
  /// `Age`
  String get age {
    return Intl.message(
      'Age',
      name: 'age',
      desc: '',
      args: [],
    );
  }
  /// `Please enter age`
  String get pleaseEnterAge {
    return Intl.message(
      'Please enter age',
      name: 'pleaseEnterAge',
      desc: '',
      args: [],
    );
  }
  /// `Please enter valid age`
  String get pleaseEnterValidAge {
    return Intl.message(
      'Please enter valid age',
      name: 'pleaseEnterValidAge',
      desc: '',
      args: [],
    );
  }
  /// `Gender`
  String get gender {
    return Intl.message(
      'Gender',
      name: 'gender',
      desc: '',
      args: [],
    );
  }
  /// `Please select gender`
  String get pleaseSelectGender {
    return Intl.message(
      'Please select gender',
      name: 'pleaseSelectGender',
      desc: '',
      args: [],
    );
  }

  /// `Role`
  String get role {
    return Intl.message(
      'Role',
      name: 'role',
      desc: '',
      args: [],
    );
  }
  /// `Please select role`
  String get pleaseSelectRole {
    return Intl.message(
      'Please select role',
      name: 'pleaseSelectRole',
      desc: '',
      args: [],
    );
  }
  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }
  /// `Welcome to TuSalud!`
  String get welcomeMessage {
    return Intl.message(
      'Welcome to TuSalud!',
      name: 'welcomeMessage',
      desc: '',
      args: [],
    );
  }
  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }
  /// `Select Role`
  String get selectRole {
    return Intl.message(
      'Select Role',
      name: 'selectRole',
      desc: '',
      args: [],
    );
  }
  /// `Select your role`
  String get selectYourRole {
    return Intl.message(
      'Select your role',
      name: 'selectYourRole',
      desc: '',
      args: [],
    );
  }
  /// `Administration`
  String get administration {
    return Intl.message(
      'Administration',
      name: 'administration',
      desc: '',
      args: [],
    );
  }
  /// `Nurse`
  String get nurse {
    return Intl.message(
      'Nurse',
      name: 'nurse',
      desc: '',
      args: [],
    );
  }
  /// `Supervisor`
  String get supervisor {
    return Intl.message(
      'Supervisor',
      name: 'supervisor',
      desc: '',
      args: [],
    );
  }
/// `Registred Rooms`
  String get registredRooms {
    return Intl.message(
      'Registred Rooms',
      name: 'registredRooms',
      desc: '',
      args: [],
    );
  }
/// `Total Rooms in Hospital`
  String get totalRoomsInHospital {
    return Intl.message(
      'Total Rooms in Hospital',
      name: 'totalRoomsInHospital',
      desc: '',
      args: [],
    );
  }
/// `Registered Beds`
  String get registeredBeds {
    return Intl.message(
      'Registered Beds',
      name: 'registeredBeds',
      desc: '',
      args: [],
    );
  }
/// `Total Beds in Hospital`
  String get totalBedsInHospital {
    return Intl.message(
      'Total Beds in Hospital',
      name: 'totalBedsInHospital',
      desc: '',
      args: [],
    );
  }
/// `Registered Bachelor Nursing`
  String get registeredBachelorNursing {
    return Intl.message(
      'Licenciadas en enfermería registradas',
      name: 'registeredBachelorNursing',
      desc: '',
      args: [],
    );
  }
/// `Total Bachelor Nursing`
  String get totalBachelorNursing {
    return Intl.message(
      'Total de licenciadas en enfermería en el hospital',
      name: 'totalBachelorNursing',
      desc: '',
      args: [],
    );
  }
/// `Registered Nursing`
  String get registeredNursing {
    return Intl.message(
      'Auxiliares de enfermería registrados',
      name: 'registeredNursing',
      desc: '',
      args: [],
    );
  }
/// `Total Nursing`
  String get totalNursing {
    return Intl.message(
      'Total de auxiliares de enfermería',
      name: 'totalNursing',
      desc: '',
      args: [],
    );
  }
/// `Beds Count`
  String get bedsCounts {
    return Intl.message(
      'Contidad de camas',
      name: 'bedsCount',
      desc: '',
      args: [],
    );
  }
/// `Hospital Managment`
  String get hospitalManagement {
    return Intl.message(
      'Gestión del Hospital',
      name: 'hospitalManagement',
      desc: '',
      args: [],
    );
  }
/// `Cantidad de habitaciones`
  String get roomsCounts {
    return Intl.message(
      'Cantidad de habitaciones',
      name: 'roomsCounts',
      desc: '',
      args: [],
    );
  } 
/// `Retry`
  String get retry {
    return Intl.message(
      'Retry',
      name: 'retry',
      desc: '',
      args: [],
    );
  }
/// `No user data available`
  String get noUserData {
    return Intl.message(
      'No user data available',
      name: 'noUserData',
      desc: '',
      args: [],
    );
  }
/// `Personal Info`
  String get personalInfo {
    return Intl.message(
      'Personal Info',
      name: 'personalInfo',
      desc: '',
      args: [],
    );
  }
/// `Born Date`
  String get bornDate {
    return Intl.message(
      'Born Date',
      name: 'bornDate',
      desc: '',
      args: [],
    );
  }
/// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }
}
class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[Locale.fromSubtags(languageCode: 'es')];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
