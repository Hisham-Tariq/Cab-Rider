import '../utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';

import '../theme/text_theme.dart';

class AppName extends StatelessWidget {
  const AppName({Key? key, this.textSize = 24.0}) : super(key: key);
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _appNameText(context, "cab "),
        _appNameText(context, "rider"),
      ],
    );
  }

  Row _appNameText(BuildContext context, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value[0].toUpperCase(),
          style: AppTextStyle(
            fontSize: ResponsiveSize.height(textSize),
            fontWeight: FontWeight.bold,
            color: context.theme.colorScheme.primary,
          ),
        ),
        Text(
          value.substring(1).toUpperCase(),
          style: AppTextStyle(
            fontSize: ResponsiveSize.height(textSize),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
