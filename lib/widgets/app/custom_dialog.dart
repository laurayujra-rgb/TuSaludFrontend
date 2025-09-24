import 'package:flutter/material.dart';
import 'package:tusalud/style/app_style.dart';

class CustomDialogPermission extends StatelessWidget {
  final String title, content, positiveBtnText, negativeBtnText;
  final GestureTapCallback? positiveBtnPressed, negativeBtnPressed;
  final IconData? iconData;
  final double? width;
  const CustomDialogPermission({
    super.key,
    required this.title,
    required this.content,
    required this.positiveBtnText,
    required this.negativeBtnText,
    this.iconData,
    this.positiveBtnPressed,
    this.negativeBtnPressed,
    this.width
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: SizedBox(
        width: width,
        child: _buildDialogContent(context)
      ),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          // Bottom rectangular box
          margin: const EdgeInsets.only(top: 40), // to push the box half way below circle
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 16), // spacing inside the box
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Center(
                child: Text(
                  content,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              OverflowBar (
                alignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (positiveBtnPressed != null)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                        )
                      ),
                      child: Text(negativeBtnText, style: const TextStyle(color: Colors.white)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  if (positiveBtnPressed == null)
                    SizedBox(
                      width: 250,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppStyle.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                          )
                        ),
                        onPressed: negativeBtnPressed ?? () => Navigator.of(context).pop(),
                        child: Text(negativeBtnText, style: const TextStyle(color: Colors.white)),
                      ),
                    ),
                  if (positiveBtnPressed != null)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppStyle.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                        )
                      ),
                      onPressed: positiveBtnPressed,
                      child: Text(positiveBtnText, style: const TextStyle(color: Colors.white)),
                    ),
                ],
              ),
            ],
          ),
        ),
        CircleAvatar(
          backgroundColor: AppStyle.primary,
          // Top Circle with icon
          maxRadius: 40.0,
          child: Icon(
            iconData,
            color: AppStyle.white,
            size: 30,
          )
        ),
      ],
    );
  }
}