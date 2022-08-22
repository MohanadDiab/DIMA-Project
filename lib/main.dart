import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/constants/routes.dart';
import 'package:testapp/helpers/loading/loading_screen.dart';
import 'package:testapp/services/auth/bloc/auth_bloc.dart';
import 'package:testapp/services/auth/bloc/auth_event.dart';
import 'package:testapp/services/auth/bloc/auth_state.dart';
import 'package:testapp/services/auth/firebase_auth_provider.dart';
import 'package:testapp/services/cloud/cloud_service.dart';
import 'package:testapp/views/forgot_password_view.dart';
import 'package:testapp/views/login_view.dart';
import 'package:testapp/views/driver_pages/page_builder_driver.dart';
import 'package:testapp/views/notes/create_update_note_view.dart';
import 'package:testapp/views/register_view.dart';
import 'package:testapp/views/seller_pages/page_builder_seller.dart';
import 'package:testapp/views/seller_pages/request_edit.dart';
import 'package:testapp/views/verify_email_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:testapp/views/welcome_screen.dart';
import 'views/seller_pages/request_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      title: 'Delever',
      debugShowCheckedModeBanner: false,
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        driverUI: (context) => const DriverPageBuilder(),
        sellerUI: (context) => const SellerPageBuilder(),
        requests: (context) => const Requests(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const WelcomeScreen();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
