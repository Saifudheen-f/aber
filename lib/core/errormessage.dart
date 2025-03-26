import 'package:firebase_auth/firebase_auth.dart';

String getFriendlyErrorMessage(FirebaseAuthException e) {
  switch (e.code) {
    case 'user-not-found':
      return 'No user found for this email.';
    case 'wrong-password':
      return 'Incorrect password. Please try again.';
    case 'invalid-email':
      return 'The email address is badly formatted.';
    case 'user-disabled':
      return 'This user account has been disabled.';
    case 'too-many-requests':
      return 'Too many login attempts. Please try again later.';
    case 'operation-not-allowed':
      return 'This sign-in method is not allowed. Please contact support.';
    case 'email-already-in-use':
      return 'The email address is already in use by another account.';
    case 'weak-password':
      return 'The password provided is too weak. Please choose a stronger password.';
    case 'network-request-failed':
      return 'Network error. Please check your internet connection and try again.';
    case 'credential-already-in-use':
      return 'This credential is already associated with a different user account.';
    case 'requires-recent-login':
      return 'This operation is sensitive and requires a recent login. Please log in again and try.';
    case 'account-exists-with-different-credential':
      return 'An account already exists with the same email address but different sign-in credentials.';
    case 'invalid-credential':
      return 'The provided authentication credential is invalid. Please try again.';
    case 'invalid-verification-code':
      return 'The SMS verification code used is invalid. Please try again.';
    case 'invalid-verification-id':
      return 'The verification ID used is invalid. Please try again.';
    case 'session-expired':
      return 'The verification session has expired. Please resend the verification code.';
    default:
      return 'An unknown error occurred. Please try again.';
  }
}
