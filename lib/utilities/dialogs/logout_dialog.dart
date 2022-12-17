import 'package:flutter/material.dart';
import 'package:testapp/extensions/buildcontext/loc.dart';
import 'package:testapp/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: context.loc.logout_button,
    content: context.loc.logout_dialog_prompt,
    optionsBuilder: () => {
      context.loc.cancel: false,
      context.loc.logout_button: true,
    },
  ).then(
    (value) => value ?? false,
  );
}

Future<bool> showConfirmRequestsDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Handle Delivery',
    content: 'Confirm handling of the delivery?',
    optionsBuilder: () => {
      context.loc.cancel: false,
      "Confirm": true,
    },
  ).then(
    (value) => value ?? false,
  );
}
