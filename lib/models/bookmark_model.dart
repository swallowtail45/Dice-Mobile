import 'package:cloud_firestore/cloud_firestore.dart';

class Bookmark {
  final String id;
  final String title;
  final String statusText;

  Bookmark({
    required this.id,
    required this.title,
    required this.statusText,
  });

  factory Bookmark.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Bookmark(
      id: doc.id,
      title: data['cardTitle'] ?? '',
      statusText: data['statusText'] ?? '',
    );
  }
}
