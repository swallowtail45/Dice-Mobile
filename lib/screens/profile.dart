import 'package:flutter/material.dart';
import 'app_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'homepage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AppHeader(
                title: "Profile",
                subtitle: "This is your profile",
                showAvatar: false,
              ),

              _buildHeader(),

              const SizedBox(height: 20),

              // TAB MENU
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _tabButton("Post", 0),
                  const SizedBox(width: 40),
                  _tabButton("Story", 1),
                ],
              ),
              const SizedBox(height: 10),

              // CONTENT
              tabIndex == 0 ? _buildPostList() : _buildStoryList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                  "https://i.ibb.co/SnpZrsP/umamusume.jpg",
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "telurgulung",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "i'd like to make a dnd story based on umamusume.",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statItem("3", "Story"),
              _statItem("20", "Followers"),
              _statItem("10", "Following"),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 14,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.black54),
                ),
                child: const Text("Edit", style: TextStyle(fontSize: 14)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(String val, String label) {
    return Column(
      children: [
        Text(
          val,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _tabButton(String title, int index) {
    final bool active = tabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => tabIndex = index),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: active ? FontWeight.bold : FontWeight.w500,
              color: active ? Colors.black : Colors.black54,
            ),
          ),
          if (active)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: 30,
              color: Colors.black,
            ),
        ],
      ),
    );
  }

  // ================= POST TAB =================
  Widget _buildPostList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('feeds')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(40),
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(40),
            child: Text("No post yet"),
          );
        }

        final docs = snapshot.data!.docs;

        return Column(
          children: docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: FeedItem(
                feedId: doc.id,
                username: data['username'],
                statusText: data['statusText'] ?? '',
                cardTitle: data['cardTitle'],
                cardColor: const Color(0xFF6B4F4F),
                likes: data['likes'] ?? 0,
                upvotes: data['upvotes'] ?? 0,
                comments: data['comments'] ?? 0,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // ================= STORY TAB =================
Widget _buildStoryList() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('feeds')
        .orderBy('createdAt', descending: true)
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(),
        );
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(40),
          child: Text("No story yet"),
        );
      }

      final docs = snapshot.data!.docs;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF6D4B41),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        data['cardTitle'], // menampilkan nama post
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                        overflow: TextOverflow.ellipsis, // jika terlalu panjang, potong dengan ...
                      ),
                    ),
                    const SizedBox(width: 8), // beri sedikit jarak ke icon
                    const Icon(Icons.more_horiz_rounded, color: Colors.white),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      );
    },
  );
}

}
