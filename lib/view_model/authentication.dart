import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:perfumes_app/core/state_management/user_session.dart';
import 'package:perfumes_app/data/hive_helper.dart';
import 'package:perfumes_app/model/user_model.dart';
import 'package:hive/hive.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static String verifyId = "";

  static Future<void> sentOtp({
    required String phone,
    required Function errorStep,
    required Function nextStep,
    String? name,
  }) async {
    _auth
        .verifyPhoneNumber(
      timeout: const Duration(seconds: 30),
      phoneNumber: '+962$phone',
      verificationCompleted: (phoneAuthCredential) async {
        final UserCredential userCredential =
            await _auth.signInWithCredential(phoneAuthCredential);
        if (userCredential.user != null) {
          await saveUserToHive(userCredential.user!, phoneNumber: phone);
          await UserSessionManager.saveUserSession(userCredential.user!.uid);
        }
      },
      verificationFailed: (error) async {
        print("Error: $error");
        errorStep();
      },
      codeSent: (verificationId, forceResendingToken) async {
        verifyId = verificationId;
        nextStep();
      },
      codeAutoRetrievalTimeout: (verificationId) async {},
    )
        .onError((error, stackTrace) {
      print("Error: $error");
      errorStep();
    });
  }

  static Future<void> loginWithOtp({required String otp}) async {
    final cred =
        PhoneAuthProvider.credential(verificationId: verifyId, smsCode: otp);

    try {
      final user = await _auth.signInWithCredential(cred);
      if (user.user != null) {
        await saveUserToHive(user.user!);
        await UserSessionManager.saveUserSession(user.user!.uid);
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Unknown error');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<void> saveUserToHive(User user,
      {String? name, String? phoneNumber}) async {
    UserModel appUser = UserModel(
      uid: user.uid,
      name: name ?? user.displayName,
      phoneNumber: phoneNumber ?? user.phoneNumber,
      email: user.email,
    );

    await HiveHelper.addUser(appUser);
    print("User data saved to Hive.");
  }

  static Future<void> logout() async {
    await _auth.signOut();
    await UserSessionManager.clearUserSession();
  }

  static Future<UserModel?> getUserInfo() async {
    return await UserSessionManager.getUser();
  }

  static Future<void> saveUserInfo(
      String name, String phoneNumber, String password) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await saveUserToHive(user, name: name, phoneNumber: phoneNumber);
      await UserSessionManager.saveUserSession(user.uid);
    }
  }

  static Future<bool> isLoggedin() async {
    return await UserSessionManager.isUserLoggedIn();
  }

  static Future<String> signupWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await saveUserToHive(userCredential.user!);
      await UserSessionManager.saveUserSession(userCredential.user!.uid);
      return 'Success';
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  static Future<void> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        if (userCredential.user != null) {
          await saveUserToHive(userCredential.user!);
          await UserSessionManager.saveUserSession(userCredential.user!.uid);
        }
      } on FirebaseAuthException catch (e) {
        print("Error: ${e.message}");
      } catch (e) {
        print("Error: $e");
      }
    }
  }

  static Future<void> signUpWithGoogle() async {
    await signInWithGoogle();
  }

  // Method for logging in with email and password
  static Future<String> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await saveUserToHive(userCredential.user!);
      await UserSessionManager.saveUserSession(userCredential.user!.uid);
      return 'Success';
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  // Method for verifying phone number
  Future<void> verifyPhoneNumber(
    String phoneNumber,
    Function(PhoneAuthCredential) verificationCompleted,
    Function(FirebaseAuthException) verificationFailed,
    Function(String, int?) codeSent,
    Function(String) codeAutoRetrievalTimeout,
  ) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  // Method for signing in with phone auth credential
  Future<void> signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    await _auth.signInWithCredential(phoneAuthCredential);
  }

  // Method for getting the current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Method for signing out
  Future<void> signOut() async {
    await _auth.signOut();
    await UserSessionManager.clearUserSession();
  }
}
