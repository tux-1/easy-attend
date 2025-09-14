import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyattend/core/utils/exceptions.dart';
import 'package:easyattend/modules/generate/data/models/lecture.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider
final historyServiceProvider = Provider<_HistoryService>(
  (ref) => _HistoryService(),
);

class _HistoryService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  /// Returns a stream of lectures created by the current user
  Stream<List<Lecture>> getCreatedLectures() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw AppException('User not authenticated');
    }

    return _firestore
        .collection('lectures')
        .where('ownerId', isEqualTo: currentUser.uid)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Lecture.fromFirestore(doc)).toList(),
        );
  }

  /// Returns a stream of lectures that the current user has attended
  Stream<List<Lecture>> getAttendedLectures() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw AppException('User not authenticated');
    }

    return _firestore
        .collection('lectures')
        .where('attendantsId', arrayContains: currentUser.uid)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Lecture.fromFirestore(doc)).toList(),
        );
  }

  /// Deletes a lecture created by the current user
  /// 
  /// Returns true if deletion was successful, throws an exception otherwise
  Future<bool> deleteLecture(String lectureId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw AppAuthException('User not authenticated');
    }
    
    try {
      // First, get the lecture to verify ownership
      final lectureDoc = await _firestore.collection('lectures').doc(lectureId).get();
      
      if (!lectureDoc.exists) {
        throw AppDataException('Lecture not found');
      }
      
      final lectureData = lectureDoc.data();
      if (lectureData == null) {
        throw AppDataException('Lecture data is null');
      }
      
      // Verify that the current user is the owner of the lecture
      if (lectureData['ownerId'] != currentUser.uid) {
        throw AppPermissionException('You do not have permission to delete this lecture');
      }
      
      // Delete the lecture
      await _firestore.collection('lectures').doc(lectureId).delete();
      
      return true;
    } on FirebaseException catch (e) {
      throw AppDataException('Failed to delete lecture: ${e.message}');
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw AppDataException('An unexpected error occurred: $e');
    }
  }
}
