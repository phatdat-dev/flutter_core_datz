import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../shared/utils/my_helper_widget.dart';
import '../../authentication/login/controller/login_controller.dart';

class LogOutButtonWidget extends StatelessWidget {
  const LogOutButtonWidget({super.key, this.backgroundColor, this.foregroundColor});
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: () => LoginController.onLogout(),
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor ?? Theme.of(context).highlightColor.withValues(alpha: 0.2),
          foregroundColor: foregroundColor ?? Theme.of(context).colorScheme.onSurface,
          side: MyHelperWidget.borderSide(context),
        ),
        child: Text(LocaleKeys.Logout.tr()),
      ),
    );
  }
}
