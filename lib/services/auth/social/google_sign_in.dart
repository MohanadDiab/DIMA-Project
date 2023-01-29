import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

Future<AuthUser> signInWithGoogleProvider() async {
  try {
    final userGoogle = await signInWithGoogle();
    if (userGoogle.additionalUserInfo?.isNewUser ?? false) {
      final userId = userGoogle.user?.uid ?? "null";
      final name = userGoogle.user?.displayName ?? "No name found";
      final phoneNumber = userGoogle.user?.phoneNumber ?? "0000";
      final number = int.parse(phoneNumber);
      const city = "Milan";
      CloudService().createSellerProfile(
          userId: userId,
          name: name,
          city: city,
          number: number,
          address: 'null',
          lat: 10,
          lng: 10);
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

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  if (await GoogleSignIn().isSignedIn() == true) {
    await GoogleSignIn().disconnect();
  }
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
