import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int tabIndex = 0;

  List<String> _storyList = [
    "Kesatria Gelap Pemburu Myth",
    "Orang Malas Melawan Dunia",
    "Legenda Kucing Terbang",
  ];

  void _openEditProfile() {
    showDialog(
      context: context,
      barrierDismissible: true, // klik luar menutup
      builder: (context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),

              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // BACK BUTTON
                    Align(
                      alignment: Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back, size: 26),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // TITLE
                    const Text(
                      "Edit Profile",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Update your profile to the latest",
                      style: TextStyle(color: Colors.black54),
                    ),

                    const SizedBox(height: 20),

                    // AVATAR
                    Center(
                      child: Stack(
                        children: [
                          const CircleAvatar(
                            radius: 45,
                            backgroundImage: NetworkImage(
                              "https://i.ibb.co/SnpZrsP/umamusume.jpg",
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.black,
                              child: Image.asset(
                                "assets/images/edit-button.png",
                                width: 20,
                                height: 20,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    buildLabel("Name"),
                    buildInput("telurgulung"),

                    const SizedBox(height: 18),

                    buildLabel("Description"),
                    buildTextarea(
                      "i'd like to make a dnd story based on umamusume.",
                    ),

                    const SizedBox(height: 18),

                    buildLabel("Email"),
                    buildInput("telurgulung@gmail.com"),

                    const SizedBox(height: 18),

                    buildLabel("Password"),
                    buildInput("tel***qwerty", obscure: true),

                    const SizedBox(height: 30),

                    // CONFIRM BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3E3636),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Confirm",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget buildInput(String value, {bool obscure = false}) {
    return TextField(
      obscureText: obscure,
      controller: TextEditingController(text: value),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget buildTextarea(String value) {
    return TextField(
      controller: TextEditingController(text: value),
      maxLines: 3,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
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

  // ---------------- HEADER PROFILE ----------------

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // FOTO + NAMA + BIO
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
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

          // STORY – FOLLOWERS – FOLLOWING – EDIT BUTTON
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statItem("3", "Story"),
              _statItem("20", "Followers"),
              _statItem("10", "Following"),

              // TOMBOL EDIT
              GestureDetector(
                onTap: _openEditProfile, // ⬅ panggil dialog edit
                child: Container(
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

  // ---------------- TAB BUTTON ----------------

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

  // ---------------- POST LIST ----------------

  Widget _buildPostList() {
    return Column(
      children: [
        _postItem(
          "Just post my new story",
          "Anomali Legenda Seluler yang Malas",
        ),
        _postItem("Just post my new story", "Orang Malas"),
      ],
    );
  }

  Widget _postItem(String text, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                  "https://i.ibb.co/SnpZrsP/umamusume.jpg",
                ),
              ),
              SizedBox(width: 10),
              Text(
                "telurgulung",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(text, style: const TextStyle(fontSize: 15)),

          const SizedBox(height: 10),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF6B4F4F),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(title, style: const TextStyle(color: Colors.white)),
          ),

          const SizedBox(height: 10),

          Row(
            children: const [
              Icon(Icons.favorite_border),
              SizedBox(width: 4),
              Text("80"),
              SizedBox(width: 20),
              Icon(Icons.share_outlined),
              SizedBox(width: 4),
              Text("80"),
              SizedBox(width: 20),
              Icon(Icons.comment_outlined),
              SizedBox(width: 4),
              Text("80"),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- STORY LIST (EXAMPLE) ----------------

  Widget _buildStoryList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: List.generate(_storyList.length, (index) {
          final item = _storyList[index];
          final GlobalKey menuKey = GlobalKey();

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),

                // LONG PRESS → popup menu
                onLongPress: () async {
                  final RenderBox button =
                      menuKey.currentContext!.findRenderObject() as RenderBox;
                  final RenderBox overlay =
                      Overlay.of(context).context.findRenderObject()
                          as RenderBox;

                  final Offset pos = button.localToGlobal(Offset.zero);

                  final value = await showMenu(
                    context: context,
                    color: Colors.white,
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    position: RelativeRect.fromLTRB(
                      pos.dx,
                      pos.dy + button.size.height,
                      overlay.size.width - pos.dx - button.size.width,
                      0,
                    ),
                    items: const [
                      PopupMenuItem(value: "view", child: Text("View")),
                      PopupMenuItem(value: "delete", child: Text("Delete")),
                      PopupMenuItem(value: "favorite", child: Text("Favorite")),
                    ],
                  );

                  if (value != null) {
                    print("$value via long press (Story)");
                  }
                },

                onTap: () {
                  print("Story item ditekan");
                },

                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6D4B41),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),

                      // TITIK TIGA
                      InkWell(
                        key: menuKey,
                        onTap: () async {
                          final RenderBox button =
                              menuKey.currentContext!.findRenderObject()
                                  as RenderBox;
                          final RenderBox overlay =
                              Overlay.of(context).context.findRenderObject()
                                  as RenderBox;

                          final Offset pos = button.localToGlobal(Offset.zero);

                          final value = await showMenu(
                            context: context,
                            color: Colors.white,
                            elevation: 6,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            position: RelativeRect.fromLTRB(
                              pos.dx,
                              pos.dy + button.size.height,
                              overlay.size.width - pos.dx - button.size.width,
                              0,
                            ),
                            items: const [
                              PopupMenuItem(value: "view", child: Text("View")),
                              PopupMenuItem(
                                value: "delete",
                                child: Text("Delete"),
                              ),
                              PopupMenuItem(
                                value: "favorite",
                                child: Text("Favorite"),
                              ),
                            ],
                          );

                          if (value != null) {
                            print("$value via titik tiga (Story)");
                          }
                        },
                        child: const Icon(
                          Icons.more_horiz_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
