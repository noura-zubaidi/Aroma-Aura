import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:perfumes_app/core/state_management/user_session.dart';
import 'package:perfumes_app/data/hive_helper.dart';
import 'package:perfumes_app/model/user_model.dart';
import 'package:hive/hive.dart';
import 'package:perfumes_app/view_model/orders_service.dart';

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
          await saveUserToDatabase(userCredential.user!, phoneNumber: phone);
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
        await saveUserToDatabase(user.user!);
        await UserSessionManager.saveUserSession(user.user!.uid);
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Unknown error');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<void> saveUserToDatabase(User user,
      {String? name, String? phoneNumber}) async {
    UserModel appUser = UserModel(
      uid: user.uid,
      name: name ?? user.displayName,
      phoneNumber: phoneNumber ?? user.phoneNumber,
      email: user.email,
    );

    await saveUserToRealtimeDatabase(appUser);
    print("User data saved to real-time database.");
  }

  static Future<void> saveUserToRealtimeDatabase(UserModel user) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child("users").child(user.uid!);
    await databaseReference.set(user.toMap());
    print('User data saved in real-time database');
  }

  static Future<UserModel?> getUserInfoFromRealtimeDatabase() async {
    final user = _auth.currentUser;
    if (user == null) {
      return null;
    }

    final databaseReference =
        FirebaseDatabase.instance.ref().child('users/${user.uid}');
    final DatabaseEvent event = await databaseReference.once();
    final DataSnapshot snapshot = event.snapshot;

    if (snapshot.exists) {
      final Map<String, dynamic> userData =
          Map<String, dynamic>.from(snapshot.value as Map);
      return UserModel.fromMap(userData);
    }
    return null;
  }

  static Future<void> logout() async {
    await _auth.signOut();
    await UserSessionManager.clearUserSession();
  }

  static Future<UserModel?> getUserInfo() async {
    return await UserSessionManager.getUser();
  }

  static Future<bool> isLoggedIn() async {
    return await UserSessionManager.isUserLoggedIn();
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
          await saveUserToDatabase(userCredential.user!);
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

  Future<void> signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    await _auth.signInWithCredential(phoneAuthCredential);
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  static Future<void> updateUserRealTime(UserModel user) async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child("users").child(user.uid!);
    await databaseReference.update(user.toMap());
    print('User info updated in real-time database');
  }

  static Future<void> updateUserInfo(String uid,
      {String? name, String? phoneNumber}) async {
    UserModel? user = await getUserInfoFromRealtimeDatabase();
    if (user != null) {
      if (name != null) user.name = name;
      if (phoneNumber != null) user.phoneNumber = phoneNumber;

      await updateUserRealTime(user);
      print("User data updated in real-time database");
    }
  }

  static OrdersService getOrdersService() {
    return OrdersService();
  }
}
