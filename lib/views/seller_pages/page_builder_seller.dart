import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/custom_widgets.dart';
import 'package:testapp/services/auth/bloc/auth_bloc.dart';
import 'package:testapp/services/auth/bloc/auth_event.dart';
import 'package:testapp/utilities/dialogs/logout_dialog.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GenericButton(
          primaryColor: color4,
          pressColor: color3,
          textColor: color2,
          text: 'Sign out',
          onPressed: () async {
            final shouldLogout = await showLogOutDialog(context);
            if (shouldLogout) {
              context.read<AuthBloc>().add(
                    const AuthEventLogOut(),
                  );
            }
          },
        ),
      ),
    );
  }
}
