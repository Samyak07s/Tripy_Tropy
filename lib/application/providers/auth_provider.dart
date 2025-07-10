import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../data/models/user_model.dart';

final authProvider =
    StateNotifierProvider<AuthController, AsyncValue<UserModel?>>(
  (ref) => AuthController(),
);

class AuthController extends StateNotifier<AsyncValue<UserModel?>> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthController() : super(const AsyncValue.data(null)) {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    try {
      final firebaseUser = _auth.currentUser;
      final user = mapFirebaseUserToUserModel(firebaseUser);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  UserModel? mapFirebaseUserToUserModel(User? user) {
    if (user == null) return null;

    return UserModel(
      email: user.email ?? '',
      name: user.displayName ?? 'User', // fallback name
    );
  }

  Future<void> signup(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = AsyncValue.data(
        UserModel(
            email: email, name: credential.user?.displayName ?? "New User"),
      );
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      state = const AsyncValue.loading();
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credential.user;

      state = AsyncValue.data(
        firebaseUser == null
            ? null
            : UserModel(
                email: firebaseUser.email ?? '',
                name: firebaseUser.displayName ?? 'Anonymous',
              ),
      );

      return true;
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
      return false;
    }
  }

  void logout() {
    state = const AsyncValue.data(null);
  }

//===================================================================================================================================

  Future<bool> signInWithGoogle() async {
    try {
      state = const AsyncValue.loading();

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        state = const AsyncValue.data(null); // user canceled
        return false;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      final user = userCredential.user;
      if (user != null) {
        state = AsyncValue.data(UserModel(
            email: user.email ?? '', name: user.displayName ?? 'Google User'));
      } else {
        state = const AsyncValue.data(null);
      }
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
      return false;
    }
  }
}
