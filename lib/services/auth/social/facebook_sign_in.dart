import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:testapp/services/auth/auth_exceptions.dart';
import 'package:testapp/services/auth/auth_user.dart';
import 'package:testapp/services/cloud/cloud_service.dart';

@override
AuthUser? get currentUser {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return AuthUser.fromFirebase(user);
  } else {
    return null;
  }
}

Future<AuthUser> signInWithFacebookProvider() async {
  try {
    final userGoogle = await signInWithFacebook();
    if (userGoogle.additionalUserInfo?.isNewUser ?? false) {
      final userId = userGoogle.user?.uid ?? "null";
      final name = userGoogle.user?.displayName ?? "No name found";
      final phoneNumber = userGoogle.user?.phoneNumber ?? "0000";
      final number = int.parse(phoneNumber);
      const city = "Milan";
      CloudService().createSellerProfile(
          userId: userId, name: name, city: city, number: number);
    }
    final user = currentUser;
    if (user != null) {
      return user;
    } else {
      throw UserNotLoggedInAuthException();
    }
  } on FirebaseAuthException {
    throw GenericAuthException;
    //showSnackBar(context, "There was a problem with Facebook login!");
  }
}

Future<UserCredential> signInWithFacebook() async {
  // Trigger the sign-in flow
  final LoginResult loginResult = await FacebookAuth.instance.login();

  // Create a credential from the access token
  final OAuthCredential facebookAuthCredential =
      FacebookAuthProvider.credential(loginResult.accessToken!.token);

  // Once signed in, return the UserCredential
  return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
}
