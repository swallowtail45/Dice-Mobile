import 'package:flutter/material.dart';
import 'app_header.dart'; // Pastikan file ini ada
// import 'navbar.dart'; // Jika ingin memanggil navbar di sini juga

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // --- PALET WARNA (Sesuai DiceRollerPage) ---
  final Color clrResultBrown = const Color(0xFF755C52);
  final Color clrDarkButton = const Color(0xFF33333D);
  final Color clrGrayBox = const Color(0xFFD6DBDC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // --- BACKGROUND PATTERN (Opsional, agar sama dengan Dice Page) ---
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Image.network(
                'https://i.pinimg.com/originals/e8/34/08/e8340882583842c38d41577782163353.jpg',
                fit: BoxFit.cover,
                errorBuilder: (c, o, s) => Container(color: Colors.white),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // 1. HEADER (Konsisten)
                const AppHeader(
                  title: "Hello User",
                  subtitle: "What are you going to do today?",
                ),

                // 2. KONTEN SCROLLABLE
                Expanded(
                  child: ListView(
                    // PADDING 24.0 (Sesuai Acuan)
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
                    children: [
                      const SizedBox(height: 10),

                      // Input Box (Create Story)
                      _buildCreateStoryBox(),

                      const SizedBox(height: 30),

                      // Feed Item 1
                      FeedItem(
                        username: "gardiono ke-2",
                        avatarUrl: "https://i.pravatar.cc/150?img=11",
                        statusText: "Just post my new story",
                        cardTitle: "Kesatria Gelap Pemburu Myth",
                        cardColor: clrResultBrown, // Menggunakan warna acuan
                        likes: 80,
                        upvotes: 80,
                        comments: 80,
                      ),

                      // Feed Item 2
                      FeedItem(
                        username: "penyembah_kacamata",
                        avatarUrl: "https://i.pravatar.cc/150?img=33",
                        statusText: "My kisah cik",
                        cardTitle: "My Kisah: Waguro dan Rintara arts",
                        cardColor: clrResultBrown, // Menggunakan warna acuan
                        likes: 12,
                        upvotes: 5,
                        comments: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // JIKA INGIN NAVBAR MUNCUL DI SINI JUGA:
          /*
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomNavbar(
              selectedIndex: 0, // 0 untuk Home/Profile
              onTap: (index) { print("Nav $index"); },
            ),
          ),
          */
        ],
      ),
    );
  }

  Widget _buildCreateStoryBox() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white, // Atau clrGrayBox jika ingin abu-abu penuh
        borderRadius: BorderRadius.circular(16),
        // Border dibuat mirip style DiceRoller (Colors.black12 atau grey.shade300)
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "I just make a new story...",
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          // Tombol Upload (Warna clrDarkButton)
          Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: clrDarkButton, // 0xFF33333D
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: const Icon(Icons.upload_file, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

// =========================================
// Feed Item Widget
// =========================================
class FeedItem extends StatelessWidget {
  final String username;
  final String avatarUrl;
  final String statusText;
  final String cardTitle;
  final Color cardColor;
  final int likes;
  final int upvotes;
  final int comments;

  const FeedItem({
    super.key,
    required this.username,
    required this.avatarUrl,
    required this.statusText,
    required this.cardTitle,
    required this.cardColor,
    required this.likes,
    required this.upvotes,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Row
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(avatarUrl),
                onBackgroundImageError: (_, __) {},
              ),
              const SizedBox(width: 10),
              Text(
                username,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Status Text
          Text(statusText, style: const TextStyle(color: Colors.black87)),
          const SizedBox(height: 12),

          // The Card (Warna clrResultBrown dari parameter)
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
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Action Icons Row
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
              const Icon(Icons.bookmark_add_outlined, color: Colors.black54),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconStat(IconData icon, int count, Color iconColor) {
    return Row(
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 4),
        Text(
          "$count",
          style: const TextStyle(color: Colors.black54, fontSize: 13),
        ),
      ],
    );
  }
}
