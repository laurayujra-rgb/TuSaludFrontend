import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tusalud/generated/l10.dart';
import 'package:tusalud/providers/admin/role_provider.dart';
import 'package:tusalud/providers/auth/registe_user_provider.dart';
import 'package:tusalud/style/app_style.dart';
import 'package:tusalud/widgets/app/custom_app_bar.dart';
import 'package:tusalud/widgets/app/custom_field.dart';
import '../../providers/admin/gender_provider.dart';
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

  // Controllers
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _dniController = TextEditingController();
  final _ageController = TextEditingController();

  // Dropdown values
  String? _selectedGenderId;
  String? _selectedRoleId;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GenderAdminProvider>(context, listen: false).loadGenders();
      Provider.of<RoleAdminProvider>(context, listen: false).loadRoles();
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
        _birthdateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final registerUserProvider =
        Provider.of<RegisterUserProvider>(context, listen: false);

    await registerUserProvider.registerUser(
      _nameController.text,
      _surnameController.text,
      "", // mother surname (si no tienes campo extra)
      _dniController.text,
      _birthdateController.text,
      int.tryParse(_ageController.text) ?? 0,
      int.parse(_selectedGenderId!),
      int.parse(_selectedRoleId!),
    );

    if (registerUserProvider.errorMessage == null) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).registrationSuccessful)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(registerUserProvider.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final registerUserProvider = Provider.of<RegisterUserProvider>(context);

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
            validator: (value) =>
                (value == null || value.isEmpty) ? S.of(context).pleaseEnterName : null,
          ),
          const SizedBox(height: 16),

          // Surname
          CustomField(
            controller: _surnameController,
            hintText: S.of(context).surname,
            keyboardType: TextInputType.name,
            prefixIcon:
                const Icon(Icons.person_outline, color: AppStyle.primary),
            validator: (value) =>
                (value == null || value.isEmpty) ? S.of(context).pleaseEnterSurname : null,
          ),
          const SizedBox(height: 16),

          // Birthdate
          TextFormField(
            controller: _birthdateController,
            decoration: InputDecoration(
              hintText: S.of(context).birthdate,
              prefixIcon:
                  const Icon(Icons.calendar_today, color: AppStyle.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide:
                    const BorderSide(color: AppStyle.primary, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide:
                    const BorderSide(color: AppStyle.primary, width: 1.0),
              ),
            ),
            readOnly: true,
            onTap: () => _selectDate(context),
            validator: (value) =>
                (value == null || value.isEmpty) ? S.of(context).pleaseSelectBirthdate : null,
          ),
          const SizedBox(height: 16),

          // DNI
          CustomField(
            controller: _dniController,
            hintText: S.of(context).dni,
            keyboardType: TextInputType.number,
            prefixIcon: const Icon(Icons.credit_card, color: AppStyle.primary),
            validator: (value) =>
                (value == null || value.isEmpty) ? S.of(context).pleaseEnterDni : null,
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
          Consumer<GenderAdminProvider>(
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
                  prefixIcon:
                      const Icon(Icons.transgender, color: AppStyle.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        const BorderSide(color: AppStyle.primary, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        const BorderSide(color: AppStyle.primary, width: 1.0),
                  ),
                ),
                validator: (value) =>
                    (value == null || value.isEmpty) ? S.of(context).pleaseSelectGender : null,
              );
            },
          ),
          const SizedBox(height: 16),

          // Role Dropdown
          Consumer<RoleAdminProvider>(
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
                    borderSide:
                        const BorderSide(color: AppStyle.primary, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide:
                        const BorderSide(color: AppStyle.primary, width: 1.0),
                  ),
                ),
                validator: (value) =>
                    (value == null || value.isEmpty) ? S.of(context).pleaseSelectRole : null,
              );
            },
          ),

          const SizedBox(height: 24),

          if (registerUserProvider.isLoading)
            const CircularProgressIndicator(color: AppStyle.primary)
          else
            CustomButton(
              text: S.of(context).register,
              onPressed: _submitForm,
            ),

          if (registerUserProvider.errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                registerUserProvider.errorMessage!,
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
    _dniController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}
