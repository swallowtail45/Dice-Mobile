import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String userId;
  final String fileName;
  final int fileSize;
  final Timestamp createdAt;

  PostModel({
    required this.id,
    required this.userId,
    required this.fileName,
    required this.fileSize,
    required this.createdAt,
  });

  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return PostModel(
      id: doc.id,
      userId: data['userId'],
      fileName: data['fileName'],
      fileSize: data['fileSize'],
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'fileName': fileName,
      'fileSize': fileSize,
      'createdAt': createdAt,
    };
  }
}
