import 'package:flutter/material.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/custom_widgets.dart';
import 'package:testapp/extensions/buildcontext/loc.dart';
import 'package:testapp/services/auth/auth_exceptions.dart';
import 'package:testapp/services/auth/bloc/auth_bloc.dart';
import 'package:testapp/services/auth/bloc/auth_event.dart';
import 'package:testapp/services/auth/bloc/auth_state.dart';
import 'package:testapp/utilities/dialogs/error_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
              context,
              context.loc.login_error_cannot_find_user,
            );
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(
              context,
              context.loc.login_error_wrong_credentials,
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              context.loc.login_error_auth_error,
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
                  GenericText(text: 'Login to your account!', color: color3),
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
                        text: context.loc.login,
                        onPressed: () async {
                          final email = _email.text;
                          final password = _password.text;
                          context.read<AuthBloc>().add(
                                AuthEventLogIn(
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
                        text: 'Register here!',
                        onPressed: () {
                          context.read<AuthBloc>().add(
                                const AuthEventShouldRegister(),
                              );
                        },
                        textColor: color2),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            const AuthEventForgotPassword(),
                          );
                    },
                    child: GenericText5(
                      text: context.loc.login_view_forgot_password,
                      color: color5,
                    ),
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
