import 'package:flutter/material.dart';
import 'package:tusalud/style/app_style.dart';


class CustomButton extends StatelessWidget {
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? color;
  final double? height;
  final VoidCallback? onPressed;
  final String text;
  final double width;

  const CustomButton({
    super.key,
    this.backgroundColor,
    this.borderColor,
    this.color = AppStyle.white,
    this.height = 50,
    required this.onPressed,
    required this.text,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppStyle.primary,
          elevation: 0,
          foregroundColor: AppStyle.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: borderColor ?? AppStyle.primary,
              width: 1
            )
          ),
          surfaceTintColor: Colors.transparent,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600
          ),
          shadowColor: Colors.black,
        ),
        child: Text(text,
          style: TextStyle(
            color: color,
            fontSize: 16, 
            fontWeight: FontWeight.w600
          ),
        ),
      )
    );
  }
}