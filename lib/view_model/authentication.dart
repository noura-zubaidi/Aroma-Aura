import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static String verifyId = "";

  static Future sentOtp({
    required String phone,
    required Function errorStep,
    required Function nextStep,
  }) async {
    _auth
        .verifyPhoneNumber(
            timeout: const Duration(seconds: 30),
            phoneNumber: '+962$phone',
            verificationCompleted: (phoneAuthCredential) async {
              return;
            },
            verificationFailed: (error) async {
              return;
            },
            codeSent: (verificationId, forceResendingToken) async {
              verifyId = verificationId;
              nextStep();
            },
            codeAutoRetrievalTimeout: (verificationId) async {
              return;
            })
        .onError((error, stackTrace) {
      errorStep();
    });
  }

  static Future loginWithOtp({required String otp}) async {
    final cred =
        PhoneAuthProvider.credential(verificationId: verifyId, smsCode: otp);

    try {
      final user = await _auth.signInWithCredential(cred);
      if (user.user != null) {
        return 'Success';
      } else {
        return 'Error';
      }
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  static Future logout() async {
    await _auth.signOut();
  }

  static Future<bool> isLoggedin() async {
    var user = _auth.currentUser;
    return user != null;
  }

  Future<void> verifyPhoneNumber(
      String phoneNumber,
      Function(PhoneAuthCredential) verificationCompleted,
      Function(FirebaseAuthException) verificationFailed,
      Function(String, int?) codeSent,
      Function(String) codeAutoRetrievalTimeout) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<void> signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    await _auth.signInWithCredential(phoneAuthCredential);
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
