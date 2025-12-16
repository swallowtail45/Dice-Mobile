import 'package:flutter/material.dart';
import 'app_header.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  // Warna asli dari kode Anda sebelumnya
  final Color clrItemBrown = const Color(0xFF6D4B41);

  bool isSelectionMode = false;
  bool isSelected = false;
  final GlobalKey menuKey = GlobalKey();

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

      // GestureDetector untuk exit selection mode
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: exitSelectionMode,
        child: Stack(
          children: [
            // 1. BACKGROUND (Dikembalikan seperti sebelumnya: Tidak Putih Polos)
            Positioned.fill(
              child: Opacity(
                opacity: 0.12, // Opasitas sesuai kode asli Anda
                child: Image.network(
                  // Menggunakan URL gambar yang sama untuk placeholder
                  'https://i.pinimg.com/originals/e8/34/08/e8340882583842c38d41577782163353.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (c, o, s) => Container(color: Colors.grey[100]),
                ),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  // 2. HEADER
                  const AppHeader(
                    title: "Library",
                    subtitle: "Manage your collection",
                  ),

                  // 3. KONTEN LIST
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ), // Padding asli 20
                      children: [
                        const SizedBox(height: 10),

                        buildContentItem(),

                        const SizedBox(height: 10),

                        buildBottomButton(),

                        const SizedBox(height: 100),
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

  // --- WIDGET ITEM KONTEN (Warna 0xFF6D4B41) ---
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
            color: clrItemBrown, // Warna Coklat Tua Asli
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (isSelectionMode)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: isSelected,
                      activeColor: Colors.white,
                      checkColor: Colors.black, // Check hitam sesuai kode asli
                      onChanged: (v) {
                        setState(() {
                          isSelected = v!;
                          if (!isSelected) {
                            isSelectionMode = false;
                          }
                        });
                      },
                    ),
                  ),
                ),

              const Expanded(
                child: Text(
                  "Kesatria Gelap Pemburu Myth",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),

              InkWell(
                key: menuKey,
                onTap: () async {
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
                  if (value != null) print("$value dipilih");
                },
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(Icons.more_horiz_rounded, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- TOMBOL BAWAH (Style Transparan + Border) ---
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
          // Logic warna asli: Merah jika select, Transparan jika tidak
          color: isSelectionMode ? Colors.red : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            // Border Merah jika select, Coklat jika tidak
            color: isSelectionMode ? Colors.red : clrItemBrown,
            width: 1.2,
          ),
        ),
        child: Center(
          child: Icon(
            isSelectionMode ? Icons.delete : Icons.add,
            // Icon Putih jika select, Coklat jika tidak
            color: isSelectionMode ? Colors.white : clrItemBrown,
            size: 26,
          ),
        ),
      ),
    );
  }
}
