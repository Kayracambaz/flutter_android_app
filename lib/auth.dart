// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

Future<User?> signInWithGoogle() async {
  try {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser == null) {
      return null;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    final authResult = await _auth.signInWithCredential(credential);
    final user = authResult.user;

    if (user == null) {
      return null;
    }

    print("📧 Email: ${user.email}");
    print("🆔 UID: ${user.uid}");

    return user;
  } catch (e, stack) {
    print("🔥 Error during Google sign-in: $e");
    print("🔍 Stack trace: $stack");
    return null;
  }
}

Future<void> signOutGoogle() async {
  await _googleSignIn.signOut();
  await _auth.signOut();
  print("🔓 User has been signed out.");
}
