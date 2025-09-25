import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tusalud/generated/l10.dart';
import 'package:tusalud/providers/admin/gender_provider.dart';
import 'package:tusalud/providers/admin/role_provider.dart';
import 'package:tusalud/providers/auth/sign_up_provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/widgets/app/custom_app_bar.dart';
import 'package:tusalud/widgets/app/custom_field.dart';

import '../../widgets/app/custom_button.dart';

class SignUpView extends StatelessWidget {
  static const String routerName = 'signUp';
  static const String routerPath = '/signUp';
  
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          centerTitle: true,
          text: S.of(context).signUp,
        ),
        backgroundColor: AppStyle.white,
       
        body: isMobile
            ? const SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SignUpForm(),
                    ],
                  ),
                ),
              )
            : const SignUpTabletView(),
      ),
    );
  }
}
class SignUpTabletView extends StatelessWidget {
  const SignUpTabletView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
      
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  SignUpForm(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  // Controllers
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _dniController = TextEditingController();
  final _addressController = TextEditingController();
  final _ageController = TextEditingController();

  // Dropdown values
  String? _selectedGenderId;
  String? _selectedRoleId;
  String? _selectedCountryId;
  String? _selectedCityId;

  bool _obscurePassword = true;
bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final genderProvider = Provider.of<GenderProvider>(context, listen: false);
      final roleProvider = Provider.of<RoleProvider>(context, listen: false);
      genderProvider.loadGenders();
      roleProvider.loadRoles();
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthdateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).passwordsDontMatch)),
      );
      return;
    }

    final signUpProvider = Provider.of<SignUpProvider>(context, listen: false);
    
    await signUpProvider.signup(
      _nameController.text,
      _surnameController.text,
      _birthdateController.text,
      _whatsappController.text,
      _emailController.text,
      _passwordController.text,
      _dniController.text,
      _addressController.text,
      _ageController.text,
      int.parse(_selectedGenderId!),
      int.parse(_selectedRoleId!),
      int.parse(_selectedCountryId!),
      int.parse(_selectedCityId!),
    );

    if (signUpProvider.errorMessage == null) {
      // Success - navigate or show success message
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).registrationSuccessful)),
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(signUpProvider.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final signUpProvider = Provider.of<SignUpProvider>(context);
    
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Name
          CustomField(
            controller: _nameController,
            hintText: S.of(context).name,
            keyboardType: TextInputType.name,
            prefixIcon: const Icon(Icons.person, color: AppStyle.primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).pleaseEnterName;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Surname
          CustomField(
            controller: _surnameController,
            hintText: S.of(context).surname,
            keyboardType: TextInputType.name,
            prefixIcon: const Icon(Icons.person_outline, color: AppStyle.primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).pleaseEnterSurname;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Birthdate
          TextFormField(
            controller: _birthdateController,
            decoration: InputDecoration(
              hintText: S.of(context).birthdate,
              prefixIcon: const Icon(Icons.calendar_today, color: AppStyle.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: AppStyle.primary, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: AppStyle.primary, width: 1.0),
              ),
            ),
            readOnly: true,
            onTap: () => _selectDate(context),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).pleaseSelectBirthdate;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // WhatsApp Number
          CustomField(
            controller: _whatsappController,
            hintText: S.of(context).whatsappNumber,
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(Icons.phone, color: AppStyle.primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).pleaseEnterWhatsappNumber;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Email
          CustomField(
            controller: _emailController,
            hintText: S.of(context).email,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email, color: AppStyle.primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).pleaseEnterEmail;
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return S.of(context).pleaseEnterValidEmail;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Password
            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: S.of(context).password,
                prefixIcon: const Icon(Icons.lock, color: AppStyle.primary),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: AppStyle.primary,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: AppStyle.primary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(color: AppStyle.primary),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return S.of(context).pleaseEnterPassword;
                }
                if (value.length < 6) {
                  return S.of(context).passwordTooShort;
                }
                return null;
              },
            ),

          const SizedBox(height: 16),
          
          // Confirm Password
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            decoration: InputDecoration(
              hintText: S.of(context).confirmPassword,
              prefixIcon: const Icon(Icons.lock_outline, color: AppStyle.primary),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                  color: AppStyle.primary,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: AppStyle.primary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: AppStyle.primary),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).pleaseConfirmPassword;
              }
              if (value != _passwordController.text) {
                return S.of(context).passwordsDontMatch;
              }
              return null;
            },
          ),

          const SizedBox(height: 16),
          
          // DNI
          CustomField(
            controller: _dniController,
            hintText: S.of(context).dni,
            keyboardType: TextInputType.number,
            prefixIcon: const Icon(Icons.credit_card, color: AppStyle.primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).pleaseEnterDni;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Address
          CustomField(
            controller: _addressController,
            hintText: S.of(context).address,
            keyboardType: TextInputType.streetAddress,
            prefixIcon: const Icon(Icons.home, color: AppStyle.primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).pleaseEnterAddress;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Age
          CustomField(
            controller: _ageController,
            hintText: S.of(context).age,
            keyboardType: TextInputType.number,
            prefixIcon: const Icon(Icons.cake, color: AppStyle.primary),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return S.of(context).pleaseEnterAge;
              }
              if (int.tryParse(value) == null) {
                return S.of(context).pleaseEnterValidAge;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Gender Dropdown
          Consumer<GenderProvider>(
            builder: (context, genderProvider, _) {
              return DropdownButtonFormField<String>(
                value: _selectedGenderId,
                hint: Text(S.of(context).gender),
                items: genderProvider.genders.map((gender) {
                  return DropdownMenuItem<String>(
                    value: gender.genderId.toString(),
                    child: Text(gender.genderName ?? 'N/A'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGenderId = value;
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.transgender, color: AppStyle.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: AppStyle.primary, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: AppStyle.primary, width: 1.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context).pleaseSelectGender;
                  }
                  return null;
                },
              );
            },
          ),
          const SizedBox(height: 16),

          // Role Dropdown
          Consumer<RoleProvider>(
            builder: (context, roleProvider, _) {
              return DropdownButtonFormField<String>(
                value: _selectedRoleId,
                hint: Text(S.of(context).role),
                items: roleProvider.roles.map((role) {
                  return DropdownMenuItem<String>(
                    value: role.roleId.toString(),
                    child: Text(role.roleName ?? 'N/A'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRoleId = value;
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.group, color: AppStyle.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: AppStyle.primary, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: AppStyle.primary, width: 1.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return S.of(context).pleaseSelectRole;
                  }
                  return null;
                },
              );
            },
          ),
          
          const SizedBox(height: 24),
          // Submit Button
          if (signUpProvider.isLoading)
            const CircularProgressIndicator(color: AppStyle.primary)
          else
            CustomButton(
              text: S.of(context).register,
              onPressed: _submitForm,
            ),
          
          if (signUpProvider.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                signUpProvider.errorMessage!,
                style: const TextStyle(color: AppStyle.red),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _birthdateController.dispose();
    _whatsappController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dniController.dispose();
    _addressController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}