import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/bookmark_model.dart';

class BookmarkService {
  final CollectionReference _ref =
      FirebaseFirestore.instance.collection('bookmarks');

  Stream<List<Bookmark>> getBookmarks() {
    return _ref
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Bookmark.fromFirestore(doc))
              .toList();
        });
  }

  Future<void> deleteBookmark(String id) async {
    await _ref.doc(id).delete();
  }
}
