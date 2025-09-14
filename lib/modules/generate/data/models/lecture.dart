import 'package:cloud_firestore/cloud_firestore.dart';

class Lecture {
  final String id;
  final String name;
  final String ownerId;
  final GeoPoint geoPoint;
  final DateTime date;
  final int counter;
  final Set<String> attendantsId;

  Lecture({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.geoPoint,
    required this.date,
    required this.counter,
    required this.attendantsId,
  });

  factory Lecture.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Lecture(
      id: doc.id,
      name: data['name'] as String,
      ownerId: data['ownerId'] as String,
      geoPoint: data['geoPoint'] as GeoPoint,
      date: (data['date'] as Timestamp).toDate(),
      counter: data['counter'] as int,
      attendantsId: Set<String>.from(data['attendantsId'] as List),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ownerId': ownerId,
      'geoPoint': geoPoint,
      'date': date,
      'counter': counter,
      'attendantsId': attendantsId.toList(),
    };
  }
}