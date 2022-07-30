import 'package:flutter/material.dart';
import 'package:testapp/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Log out',
    content: 'Are you sure you want to log out?',
    optionsBuilder: () => {
      'Cancel': false,
      'Confirm': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
