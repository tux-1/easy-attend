import 'package:easyattend/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final void Function()? onTap;
  final Icon icon;
  const CustomIconButton({super.key, this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: AppColors.black60, blurRadius: 36)],
      ),
      child: Material(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(6),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(6),
          child: FittedBox(child: icon),
        ),
      ),
    );
  }
}

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      icon: Icon(Icons.chevron_left, color: AppColors.primary),
      onTap: () {
        Navigator.of(context).pop();
      },
    );
  }
}
