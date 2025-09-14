import 'package:firebase_auth/firebase_auth.dart';

/// Base exception class for application-specific exceptions
class AppException implements Exception {
  final String message;
  AppException(this.message);

  @override
  String toString() {
    return message;
  }
}

/// Authentication-specific exceptions
class AppAuthException extends AppException {
  AppAuthException(super.message);

  /// Factory constructor to convert Firebase Auth exceptions to app-specific exceptions
  /// with user-friendly error messages
  factory AppAuthException.fromFirebase(FirebaseAuthException e) {
    switch (e.code) {
      // Sign-in/login errors
      case 'user-not-found':
        return AppAuthException('No account found with this email');
      case 'wrong-password':
        return AppAuthException('Incorrect password');
      case 'invalid-email':
        return AppAuthException('Invalid email format');
      case 'user-disabled':
        return AppAuthException('This account has been disabled');
      case 'too-many-requests':
        return AppAuthException('Too many attempts. Please try again later');
      case 'invalid-credential':
        return AppAuthException('Invalid login credentials');
      case 'account-exists-with-different-credential':
        return AppAuthException('Account exists with different sign-in method');
      
      // Registration errors
      case 'email-already-in-use':
        return AppAuthException('Email is already registered');
      case 'operation-not-allowed':
        return AppAuthException('This sign-in method is not enabled');
      case 'weak-password':
        return AppAuthException('Password is too weak. Use a stronger password');
      
      // Password reset errors
      case 'expired-action-code':
        return AppAuthException('The reset link has expired');
      case 'invalid-action-code':
        return AppAuthException('The reset link is invalid');
      case 'user-mismatch':
        return AppAuthException('The provided credentials do not match the previous sign-in');
      
      // Network errors
      case 'network-request-failed':
        return AppAuthException('Network error. Check your connection and try again');
      
      // Default case for unhandled error codes
      default:
        // For debugging, include the error code
        return AppAuthException('Authentication failed: ${e.message ?? e.code}');
    }
  }
}

/// Exception for data-related errors
class AppDataException extends AppException {
  AppDataException(super.message);
}

/// Exception for network-related errors
class AppNetworkException extends AppException {
  AppNetworkException(super.message);
  
  factory AppNetworkException.noConnection() {
    return AppNetworkException('No internet connection. Please check your network settings');
  }
  
  factory AppNetworkException.timeout() {
    return AppNetworkException('Connection timeout. Please try again');
  }
}

/// Exception for permission-related errors
class AppPermissionException extends AppException {
  AppPermissionException(super.message);
  
  factory AppPermissionException.locationDenied() {
    return AppPermissionException('Location permission is required for attendance');
  }
  
  factory AppPermissionException.cameraDenied() {
    return AppPermissionException('Camera permission is required for scanning QR codes');
  }
}
