import 'package:flutter/material.dart';
import 'package:plus90_application/utils/app_color.dart';
import 'package:plus90_application/utils/app_style.dart';

class DialogUtils {
  static void showLoading({
    required BuildContext context,
    required String loadingText,
  }) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(color: AppColor.orange),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(loadingText, style: AppStyle.semibold20orange),
            ),
          ],
        ),
      ),
    );
  }

  static void hideLoading({required BuildContext context}) {
    Navigator.pop(context);
  }

  static void showMessage({
    required BuildContext context,
    required String message,
    String? title,
    String? posActionName,
    Function? posAction,
    String? negActionName,
    Function? negAction,
    bool barrierDismissible = true,
  }) {
    List<Widget> actions = [];
    if (posActionName != null) {
      actions.add(
        TextButton(
          onPressed: () {
            Navigator.pop(context);

            posAction?.call();
          },
          child: Text(posActionName, style: AppStyle.semibold20orange),
        ),
      );
      if (negActionName != null) {
        actions.add(
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              negAction?.call();
            },
            child: Text(negActionName, style: AppStyle.semibold20orange),
          ),
        );
      }
    }

    showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message, style: AppStyle.semibold20orange),
        title: Text(title ?? '', style: AppStyle.semibold20orange),
        actions: actions,
      ),
    );
  }
}
