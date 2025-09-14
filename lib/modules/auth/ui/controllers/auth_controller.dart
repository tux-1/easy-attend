import 'package:easyattend/modules/auth/data/models/user_data.dart';
import 'package:easyattend/modules/auth/data/repo/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthController extends AsyncNotifier<UserData?> {
  AuthRepo get _authRepo => ref.read(authRepoProvider);

  @override
  Future<UserData?> build() async {
    // Initialize with current auth state
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    try {
      return await _authRepo.getUserData(user.uid);
    } catch (e, st) {
      // Return null but keep error in state
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    state = const AsyncValue.loading();
    final user = await _authRepo.signUpWithEmailAndPassword(
      name: name,
      email: email,
      password: password,
    );
    state = AsyncValue.data(user);
  }

  Future<bool> login({required String email, required String password}) async {
    state = const AsyncValue.loading();
    final user = await _authRepo.loginWithEmailAndPassword(
      email: email,
      password: password,
    );
    state = AsyncValue.data(user);
    return true;
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authRepo.logout();
      return null;
    });
  }
}

final authControllerProvider = AsyncNotifierProvider<AuthController, UserData?>(
  () {
    return AuthController();
  },
);
