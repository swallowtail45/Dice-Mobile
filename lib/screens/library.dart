import 'package:flutter/material.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  bool isSelectionMode = false;
  bool isSelected = false;
  final GlobalKey menuKey = GlobalKey();

  // fungsi reset mode checklist
  void exitSelectionMode() {
    if (isSelectionMode) {
      setState(() {
        isSelectionMode = false;
        isSelected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,

        title: Stack(
          children: [
            Center(
              child: Column(
                children: const [
                  Text(
                    "Library",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Here is all of the added story",
                    style: TextStyle(fontSize: 11, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () => print("Profile ditekan"),
                  child: const CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage("assets/profile-nnti.jpg"),
                  ),
                ),
              ],
            ),
          ],
        ),

        actions: [
          IconButton(
            onPressed: () => print("Search"),
            icon: const Icon(Icons.search, color: Colors.black, size: 26),
          ),
          const SizedBox(width: 10),
        ],
      ),

      //detect luar area content

      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: exitSelectionMode, // klik area luar → kembali normal

        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.12,
                child: Image.asset(
                  "assets/background-nnti.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  Expanded(
                    child: ListView(
                      children: [
                        buildContentItem(),

                        const SizedBox(height: 10),
                        buildBottomButton(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //content list
  Widget buildContentItem() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),

        onLongPress: () {
          setState(() {
            isSelectionMode = true;
          });
        },

        onTap: () {
          if (isSelectionMode) {
            setState(() {
              isSelected = !isSelected;

              if (!isSelected) {
                isSelectionMode = false;
              }
            });
          } else {
            print("Content dibuka");
          }
        },

        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF6D4B41),
            borderRadius: BorderRadius.circular(10),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isSelectionMode)
                Checkbox(
                  value: isSelected,
                  activeColor: Colors.white,
                  checkColor: Colors.black,
                  onChanged: (v) {
                    setState(() {
                      isSelected = v!;

                      if (!isSelected) {
                        isSelectionMode = false;
                      }
                    });
                  },
                ),

              const Expanded(
                child: Text(
                  "Kesatria Gelap Pemburu Myth",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),

              // titik tiga
              InkWell(
                key: menuKey,
                onTap: () async {
                  final RenderBox button =
                      menuKey.currentContext!.findRenderObject() as RenderBox;

                  final RenderBox overlay =
                      Overlay.of(context).context.findRenderObject() as RenderBox;

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

                  if (value != null) print("$value dipilih");
                },

                child: const Icon(Icons.more_horiz_rounded, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }


  //add n delete btn

  Widget buildBottomButton() {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        if (isSelectionMode && isSelected) {
          print("HAPUS DATA");
          setState(() {
            isSelected = false;
            isSelectionMode = false;
          });
        } else {
          print("Tambah data");
        }
      },

      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isSelectionMode ? Colors.red : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelectionMode ? Colors.red : const Color(0xFF6D4B41),
            width: 1.2,
          ),
        ),

        child: Center(
          child: Icon(
            isSelectionMode ? Icons.delete : Icons.add,
            color: isSelectionMode ? Colors.white : const Color(0xFF6D4B41),
            size: 26,
          ),
        ),
      ),
    );
  }
}
