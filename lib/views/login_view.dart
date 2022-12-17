import 'package:flutter/material.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/constants/customPageRouter.dart';
import 'package:testapp/views/phone_login.dart';
import 'package:testapp/widgets/custom_widgets.dart';
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
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 250,
                  width: 250,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/icon/icon.png'),
                    ),
                  ),
                ),
                bigText(
                  text: 'Delevery',
                  color: color3,
                ),
                genericText(text: "Welcome back!", color: color5),
                const SizedBox(height: 10),
                Container(
                  height: 1,
                  color: color3,
                ),
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
                    const Icon(Icons.lock_outlined),
                    const SizedBox(width: 5),
                    genericText(text: 'Password', color: color5),
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
                  child: genericButton(
                      context: context,
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
                genericText(text: 'OR', color: color5),
                genericText4(
                  text: "Sign in with",
                  color: color5,
                  stringWeight: FontWeight.w300,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: color3,
                        radius: 35,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MyRoute(
                                builder: (BuildContext context) =>
                                    const PhoneScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.phone),
                          iconSize: 35,
                          color: color2,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: color3,
                        radius: 35,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.facebook),
                          iconSize: 35,
                          color: color2,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: color3,
                        radius: 35,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.mail),
                          iconSize: 35,
                          color: color2,
                        ),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          const AuthEventShouldRegister(),
                        );
                  },
                  child: genericText5(
                    text: "Don't have an account?",
                    color: color5,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          const AuthEventForgotPassword(),
                        );
                  },
                  child: genericText5(
                    text: context.loc.login_view_forgot_password,
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
