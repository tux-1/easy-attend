import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyattend/core/utils/exceptions.dart';
import 'package:easyattend/modules/generate/data/models/lecture.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

final lecturesServiceProvider = Provider<_LecturesService>(
  (ref) => _LecturesService(),
);

class _LecturesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Constants for geolocation
  final double _maxDistanceInMeters = 30.0;

  // Get lecture stream
  Stream<Lecture> getLectureStream(String lectureId) {
    return _firestore
        .collection('lectures')
        .doc(lectureId)
        .snapshots()
        .map((doc) => Lecture.fromFirestore(doc));
  }

  // Attend lecture
  Future<bool> attendLecture(String lectureId, GeoPoint userLocation) async {
    final lectureDoc =
        await _firestore.collection('lectures').doc(lectureId).get();
    if (!lectureDoc.exists) {
      throw AppException('Lecture not found');
    }

    final lecture = Lecture.fromFirestore(lectureDoc);
    final lectureLocation = lecture.geoPoint;

    // Calculate distance between user and lecture
    final distance = Geolocator.distanceBetween(
      userLocation.latitude,
      userLocation.longitude,
      lectureLocation.latitude,
      lectureLocation.longitude,
    );

    // Check if user is within range
    if (distance <= _maxDistanceInMeters) {
      final currentUser = _auth.currentUser;

      if (currentUser == null) throw AppException('User not authenticated');

      // Add user to attendants
      await _firestore.collection('lectures').doc(lectureId).update({
        'attendantsId': FieldValue.arrayUnion([currentUser.uid]),
      });
      return true;
    } else {
      throw AppException('User is too far from lecture location');
    }
  }

  // Increment counter
  Future<void> incrementRegisteredCounter(String lectureId) async {
    try {
      await _firestore.collection('lectures').doc(lectureId).update({
        'counter': FieldValue.increment(1),
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<String> generateLecture({
    required String name,
    required GeoPoint userLocation,
  }) async {
    try {
      // Get current user
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

      // Create the lecture document
      final lectureDoc = await _firestore.collection('lectures').add({
        'name': name,
        'ownerId': currentUser.uid,
        'geoPoint': userLocation,
        'date': DateTime.now(),
        'counter': 0,
        'attendantsId': <String>[],
      });

      return lectureDoc.id;
    } catch (e) {
      throw Exception('Failed to generate lecture: $e');
    }
  }
}
