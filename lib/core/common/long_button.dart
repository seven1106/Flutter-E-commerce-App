import 'package:flutter/material.dart';

import '../config/theme/app_palette.dart';

class LongButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  const LongButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppPalette.btnColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(395, 55),
          backgroundColor: AppPalette.transparentColor,
          shadowColor: AppPalette.transparentColor,
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppPalette.backgroundColor,
          ),
        ),
      ),
    );
  }
}
