import 'package:flutter/material.dart';

class CustomNavbar extends StatelessWidget {
  final int selectedIndex; // 0: Home, 1: Dice, 2: Library, 3: Profile
  final Function(int) onTap; // Fungsi ketika tombol ditekan

  const CustomNavbar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color clrDarkButton = const Color(0xFF33333D);

    return Container(
      height: 70,
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
      decoration: BoxDecoration(
        color: clrDarkButton,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, Icons.home, clrDarkButton),
          _buildNavItem(1, Icons.casino, clrDarkButton),
          _buildNavItem(2, Icons.menu_book_rounded, clrDarkButton),
          _buildNavItem(3, Icons.person, clrDarkButton),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, Color mainColor) {
    bool isSelected = selectedIndex == index;

    if (isSelected) {
      // Tampilan Tombol Aktif (Lingkaran Putih)
      return Container(
        width: 55,
        height: 55,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: mainColor, size: 30),
      );
    } else {
      // Tampilan Tombol Tidak Aktif (Icon Putih Polos)
      return IconButton(
        icon: Icon(icon, color: Colors.white, size: 30),
        onPressed: () => onTap(index),
      );
    }
  }
}
