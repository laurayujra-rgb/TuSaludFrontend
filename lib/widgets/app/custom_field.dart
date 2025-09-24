import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tusalud/style/app_style.dart';


class CustomField extends StatelessWidget {
    final double borderRadius;
  final bool? enabled;
  final String? hintText;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final String? label;
  final bool obscureText;
  final ValueChanged? onChanged;
  final GestureTapCallback? onTap;
  final Widget? prefixIcon;
  final Widget? suffixIcon; 
  
  final FormFieldValidator? validator;
  final double? width;
  final TextEditingController? controller; // Nuevo parámetro

  
  const CustomField({
    super.key,
    this.borderRadius = 8,
    this.enabled = true,
    this.hintText,
    this.initialValue,
    this.inputFormatters,
    this.keyboardType,
    this.label,
    this.obscureText = false,
    this.onChanged,
    this.onTap,
    this.prefixIcon,
    this.suffixIcon, // 👈 NUEVO
    this.validator,
    this.width = double.infinity,
    this.controller, // Añadido al constructor

  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: width,
      child: TextFormField(
        controller: controller, // Usamos el controller aquí
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: AppStyle.primary),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius))
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: enabled!? AppStyle.primary: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius))
          ),
          filled: true,
          fillColor: AppStyle.ligthGrey,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          floatingLabelStyle: const TextStyle(color: AppStyle.primary),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppStyle.primary),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius))
          ),
          hintText: hintText ?? '',
          labelStyle: const TextStyle(color: AppStyle.primary),
          labelText: hintText ?? '',
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon, // 👈 NUEVO
          prefixIconColor: AppStyle.primary,
        ),
        enabled: enabled,
        inputFormatters: inputFormatters ?? [],
        keyboardType: keyboardType,
        obscureText: obscureText,
        onTap: onTap,
        onChanged: onChanged,
        validator: validator,
      )
    );
  }
}