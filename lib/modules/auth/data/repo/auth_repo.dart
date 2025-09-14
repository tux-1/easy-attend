import 'package:easyattend/core/utils/exceptions.dart';
import 'package:easyattend/modules/auth/data/models/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepoProvider = Provider((ref) => AuthRepo());

class AuthRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserData> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Create user in Firebase Auth
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final userCreationTime = DateTime.now();

      // Save additional user data in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'createdAt': Timestamp.fromDate(userCreationTime),
      });

      return UserData(
        uid: userCredential.user!.uid,
        name: name,
        email: email,
        createdAt: userCreationTime,
      );
    } on FirebaseAuthException catch (e) {
      throw AppAuthException.fromFirebase(e);
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  Future<UserData> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      // Get user data from Firestore
      final userDoc =
          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .get();

      if (!userDoc.exists) {
        throw Exception('User document not found');
      }

      return UserData.fromFirestore(userDoc);
    } on FirebaseAuthException catch (e) {
      // Convert Firebase-specific exceptions to app-specific exceptions
      throw AppAuthException.fromFirebase(e);
    } on FirebaseException catch (e) {
      throw AppException('Firestore error: ${e.message}');
    } catch (e) {
      throw AppException('Unknown error occurred');
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<UserData> getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) throw Exception('User data not found');
    return UserData.fromFirestore(doc);
  }
}
