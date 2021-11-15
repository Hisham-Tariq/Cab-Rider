import '../../customization/customization.dart';
import 'package:flutter/material.dart';

class AppName extends StatelessWidget {
  const AppName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'C',
          style: AppTextStyle.appNamePrimary,
        ),
        Text(
          'AB',
          style: AppTextStyle.appName,
        ),
      ],
    );
  }
}
