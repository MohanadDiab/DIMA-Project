import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/widgets/custom_widgets.dart';
import 'package:testapp/extensions/buildcontext/loc.dart';
import 'package:testapp/services/auth/bloc/auth_bloc.dart';
import 'package:testapp/services/auth/bloc/auth_event.dart';
import 'package:testapp/services/auth/bloc/auth_state.dart';
import 'package:testapp/utilities/dialogs/error_dialog.dart';
import 'package:testapp/utilities/dialogs/password_reset_email_sent_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception != null) {
            await showErrorDialog(
              context,
              context.loc.forgot_password_view_generic_error,
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(50),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 250,
                  width: 250,
                  decoration: const BoxDecoration(
                    image:
                        DecorationImage(image: AssetImage('assets/logo.png')),
                  ),
                ),
                genericText(text: 'Reset your password', color: color3),
                const SizedBox(height: 25),
                Container(
                  height: 2,
                  color: color3,
                ),
                const SizedBox(height: 15),
                genericText4(
                    text: context.loc.forgot_password_view_prompt,
                    color: color5,
                    stringWeight: FontWeight.w300),
                const SizedBox(height: 25),
                Row(
                  children: [
                    const Icon(Icons.email_outlined),
                    const SizedBox(width: 5),
                    genericText(text: 'Email address', color: color5),
                    const Expanded(child: SizedBox()),
                  ],
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: context.loc.email_text_field_placeholder,
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: genericButton(
                      context: context,
                      primaryColor: color3,
                      pressColor: color2,
                      text: 'Send link',
                      onPressed: () {
                        final email = _controller.text;
                        context
                            .read<AuthBloc>()
                            .add(AuthEventForgotPassword(email: email));
                      },
                      textColor: color2),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  },
                  child: genericText5(
                    text: context.loc.forgot_password_view_back_to_login,
                    color: color5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
