import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/custom_widgets.dart';
import 'package:testapp/extensions/buildcontext/loc.dart';
import 'package:testapp/services/auth/auth_exceptions.dart';
import 'package:testapp/services/auth/bloc/auth_bloc.dart';
import 'package:testapp/services/auth/bloc/auth_event.dart';
import 'package:testapp/services/auth/bloc/auth_state.dart';
import 'package:testapp/utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(
              context,
              context.loc.register_error_weak_password,
            );
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(
              context,
              context.loc.register_error_email_already_in_use,
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              context.loc.register_error_generic,
            );
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
              context,
              context.loc.register_error_invalid_email,
            );
          }
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 250,
                    width: 250,
                    decoration: const BoxDecoration(
                      image:
                          DecorationImage(image: AssetImage('assets/logo.png')),
                    ),
                  ),
                  GenericText(text: 'Register with your email', color: color3),
                  const SizedBox(height: 25),
                  Container(
                    height: 2,
                    color: color3,
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      const Icon(Icons.email),
                      const SizedBox(width: 5),
                      GenericText(text: 'Email address', color: color5),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                  TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: context.loc.email_text_field_placeholder,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      const Icon(Icons.lock),
                      const SizedBox(width: 5),
                      GenericText(text: 'Password', color: color5),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: context.loc.password_text_field_placeholder,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: GenericButton(
                        primaryColor: color3,
                        pressColor: color2,
                        text: context.loc.register,
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;
                          context.read<AuthBloc>().add(
                                AuthEventRegister(
                                  email,
                                  password,
                                ),
                              );
                        },
                        textColor: color2),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: GenericButton(
                        primaryColor: color3,
                        pressColor: color2,
                        text: context.loc.forgot_password_view_back_to_login,
                        onPressed: () {
                          context.read<AuthBloc>().add(
                                const AuthEventLogOut(),
                              );
                        },
                        textColor: color2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
