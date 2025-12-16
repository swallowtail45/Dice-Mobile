import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'app_header.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Color clrResultBrown = const Color(0xFF755C52);
  final Color clrDarkButton = const Color(0xFF33333D);

  final TextEditingController _storyController = TextEditingController();

  // ================= POST PDF (METADATA ONLY) =================
  Future<void> _pickPdfAndPost() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result == null) return;

      final fileName = result.files.single.name;

      await FirebaseFirestore.instance.collection('feeds').add({
        'username': 'gardiono ke-2',
        'avatarUrl': '', // ⛔ hindari NetworkImage error di web
        'statusText': _storyController.text.trim(),
        'cardTitle': fileName,
        'fileType': 'pdf',
        'likes': 80,
        'upvotes': 80,
        'comments': 80,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _storyController.clear();
    } catch (e) {
      debugPrint("ERROR POST: $e");
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(
              title: "Hello User",
              subtitle: "What are you going to do today?",
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                children: [
                  const SizedBox(height: 10),
                  _buildCreateStoryBox(),
                  const SizedBox(height: 30),

                  // ================= FEED =================
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('feeds')
                        .orderBy('createdAt', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return const Center(child: Text("Belum ada feed"));
                      }

                      final docs = snapshot.data!.docs;

                      return Column(
                        children: docs.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;

                          return FeedItem(
                            feedId: doc.id,
                            username: data['username'],
                            statusText: data['statusText'] ?? '',
                            cardTitle: data['cardTitle'],
                            cardColor: clrResultBrown,
                            likes: data['likes'] ?? 0,
                            upvotes: data['upvotes'] ?? 0,
                            comments: data['comments'] ?? 0,
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= CREATE STORY =================
  Widget _buildCreateStoryBox() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _storyController,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "I just make a new story...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: _pickPdfAndPost,
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: clrDarkButton,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: const Icon(Icons.upload_file, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}

// ================= FEED ITEM =================
class FeedItem extends StatelessWidget {
  final String feedId;
  final String username;
  final String statusText;
  final String cardTitle;
  final Color cardColor;
  final int likes;
  final int upvotes;
  final int comments;

  const FeedItem({
    super.key,
    required this.feedId,
    required this.username,
    required this.statusText,
    required this.cardTitle,
    required this.cardColor,
    required this.likes,
    required this.upvotes,
    required this.comments,
  });

  // ================= ADD BOOKMARK (ANTI DUPLIKAT) =================
  Future<void> _addBookmark(BuildContext context) async {
    await FirebaseFirestore.instance.collection('bookmarks').add({
      'userId': 'dummy-user-id',
      'feedId': feedId,
      'cardTitle': cardTitle,
      'statusText': statusText,
      'createdAt': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Added to Library")));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 18, color: Colors.white),
              ),
              SizedBox(width: 10),
            ],
          ),

          const SizedBox(height: 8),
          Text(username, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(statusText),
          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              cardTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              _buildIconStat(Icons.favorite, likes, Colors.red),
              const SizedBox(width: 16),
              _buildIconStat(Icons.arrow_upward, upvotes, Colors.black54),
              const SizedBox(width: 16),
              _buildIconStat(
                Icons.chat_bubble_outline,
                comments,
                Colors.black54,
              ),
              const Spacer(),

              GestureDetector(
                onTap: () => _addBookmark(context),
                child: const Icon(
                  Icons.bookmark_add_outlined,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconStat(IconData icon, int count, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 4),
        Text("$count", style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
