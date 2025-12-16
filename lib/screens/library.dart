import 'package:flutter/material.dart';
import '../models/bookmark_model.dart';
import '../services/bookmark_service.dart';
import 'app_header.dart';

class LibraryPage extends StatefulWidget {
  final Function(int)? onNavigate;
  
  const LibraryPage({
    super.key,
    required this.onNavigate,
  });

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final Color clrItemBrown = const Color(0xFF6D4B41);
  final BookmarkService _service = BookmarkService();

  bool isSelectionMode = false;
  String? selectedId;

  void exitSelectionMode() {
    if (isSelectionMode) {
      setState(() {
        isSelectionMode = false;
        selectedId = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: exitSelectionMode,
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.12,
                child: Image.network(
                  'https://i.pinimg.com/originals/e8/34/08/e8340882583842c38d41577782163353.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: Colors.grey[100]),
                ),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  const AppHeader(
                    title: "Library",
                    subtitle: "Manage your collection",
                  ),

                  Expanded(
                    child: StreamBuilder<List<Bookmark>>(
                      stream: _service.getBookmarks(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final items = snapshot.data!;

                        if (items.isEmpty) {
                          return const Center(
                            child: Text("Library kosong"),
                          );
                        }

                        return ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          children: [
                            const SizedBox(height: 10),

                            ...items.map(
                              (e) => Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 10),
                                child: buildContentItem(e),
                              ),
                            ),

                            const SizedBox(height: 10),
                            buildBottomButton(),
                            const SizedBox(height: 100),
                          ],
                        );
                      },
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

  Widget buildContentItem(Bookmark bookmark) {
    final bool isSelected = selectedId == bookmark.id;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onLongPress: () {
          setState(() {
            isSelectionMode = true;
            selectedId = bookmark.id;
          });
        },
        onTap: () {
          if (isSelectionMode) {
            setState(() {
              selectedId = isSelected ? null : bookmark.id;
              if (selectedId == null) isSelectionMode = false;
            });
          }
        },
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
          decoration: BoxDecoration(
            color: clrItemBrown,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              if (isSelectionMode)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Checkbox(
                    value: isSelected,
                    activeColor: Colors.white,
                    checkColor: Colors.black,
                    onChanged: (v) {
                      setState(() {
                        selectedId = v! ? bookmark.id : null;
                        if (!v) isSelectionMode = false;
                      });
                    },
                  ),
                ),

              Expanded(
                child: Text(
                  bookmark.title,
                  style:
                      const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),

              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == "delete") {
                    _service.deleteBookmark(bookmark.id);
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: "view", child: Text("View")),
                  PopupMenuItem(value: "delete", child: Text("Delete")),
                  PopupMenuItem(value: "favorite", child: Text("Favorite")),
                ],
                icon: const Icon(Icons.more_horiz_rounded,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ⬇️ INI YANG PENTING
Widget buildBottomButton() {
  return InkWell(
    borderRadius: BorderRadius.circular(10),
    onTap: () {
      if (isSelectionMode && selectedId != null) {
        _service.deleteBookmark(selectedId!);
        setState(() {
          isSelectionMode = false;
          selectedId = null;
        });
      } else {
        // ⬇️ PINDAH KE TAB HOME (INDEX 0)
        widget.onNavigate?.call(0);
      }
    },
    child: Container(
      height: 50,
      decoration: BoxDecoration(
        color: isSelectionMode ? Colors.red : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelectionMode ? Colors.red : clrItemBrown,
          width: 1.2,
        ),
      ),
      child: Center(
        child: Icon(
          isSelectionMode ? Icons.delete : Icons.add,
          color: isSelectionMode ? Colors.white : clrItemBrown,
          size: 26,
        ),
      ),
    ),
  );
}

}
