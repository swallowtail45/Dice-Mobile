import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';

class PostService {
  static final _ref =
      FirebaseFirestore.instance.collection('posts');

  static Future<void> addPost(PostModel post) async {
    await _ref.add(post.toMap());
  }

  static Stream<List<PostModel>> getPosts() {
    return _ref
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((d) => PostModel.fromFirestore(d)).toList());
  }
}
