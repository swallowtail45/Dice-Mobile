import 'dart:math';
import 'package:flutter/material.dart';
import 'navbar.dart';

// ... (Class ActiveDie tetap sama, tidak berubah) ...
class ActiveDie {
  final String label;
  final int sides;
  final Color color;
  int currentValue;
  bool hasRolled;

  ActiveDie({
    required this.label,
    required this.sides,
    required this.color,
    required this.currentValue,
    this.hasRolled = false,
  });
}

class DiceRollerPage extends StatefulWidget {
  const DiceRollerPage({super.key});

  @override
  State<DiceRollerPage> createState() => _DiceRollerPageState();
}

class _DiceRollerPageState extends State<DiceRollerPage> {
  // ... (Variable List & Warna tetap sama) ...
  List<ActiveDie> activeDice = [];
  int totalResult = 0;

  final Color clrPurple = const Color(0xFFC56CE0);
  final Color clrOrange = const Color(0xFFF47B20);
  final Color clrYellow = const Color(0xFFFDCB0B);
  final Color clrGreen = const Color(0xFF80D058);
  final Color clrBlue = const Color(0xFF004AAD);
  final Color clrRed = const Color(0xFFEE3636);
  final Color clrDarkPurple = const Color(0xFF8E44AD);
  final Color clrDarkButton = const Color(0xFF33333D);
  final Color clrResultBrown = const Color(0xFF755C52);
  final Color clrGrayBox = const Color(0xFFD6DBDC);

  // ... (Fungsi _addDie, _rollAllDice, _clearDice tetap sama) ...
  void _addDie(String label, int sides, Color color) {
    setState(() {
      activeDice.add(
        ActiveDie(
          label: label,
          sides: sides,
          color: color,
          currentValue: sides,
          hasRolled: false,
        ),
      );
    });
  }

  void _rollAllDice() {
    if (activeDice.isEmpty) return;
    int currentSum = 0;
    final random = Random();
    setState(() {
      for (var die in activeDice) {
        int result = random.nextInt(die.sides) + 1;
        die.currentValue = result;
        die.hasRolled = true;
        currentSum += result;
      }
      totalResult = currentSum;
    });
  }

  void _clearDice() {
    setState(() {
      activeDice.clear();
      totalResult = 0;
    });
  }

  // Fungsi navigasi (bisa dikembangkan nanti)
  void _onNavbarTapped(int index) {
    print("Tombol navigasi ke-$index ditekan");
    // Nanti di sini logika pindah halaman (Navigator.push)
    if (index == 0) {
      // Ke Home
    } else if (index == 2) {
      // Ke Library
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background
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
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 20.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/150?img=5',
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text(
                              "Dice Roller",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Go on a game, roll now!",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 56),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          // Visual Box
                          Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                constraints: const BoxConstraints(
                                  minHeight: 200,
                                ),
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: clrGrayBox,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.black12),
                                ),
                                child: activeDice.isEmpty
                                    ? const Center(
                                        child: Text(
                                          "Tap buttons below to add dice",
                                          style: TextStyle(
                                            color: Colors.black38,
                                          ),
                                        ),
                                      )
                                    : Wrap(
                                        alignment: WrapAlignment.center,
                                        spacing: 15,
                                        runSpacing: 15,
                                        children: activeDice
                                            .map(
                                              (die) => _buildDynamicShape(die),
                                            )
                                            .toList(),
                                      ),
                              ),
                              if (activeDice.isNotEmpty)
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: InkWell(
                                    onTap: _clearDice,
                                    child: CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.white.withOpacity(
                                        0.8,
                                      ),
                                      child: const Icon(
                                        Icons.delete_outline,
                                        size: 18,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 25),

                          // Total Result
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: clrResultBrown,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 100,
                                  color: clrResultBrown,
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Total",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    color: Colors.white,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "$totalResult",
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 25),

                          // Buttons
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            alignment: WrapAlignment.center,
                            children: [
                              _buildDiceBtn("D4", 4, clrPurple),
                              _buildDiceBtn("D6", 6, clrOrange),
                              _buildDiceBtn("D8", 8, clrYellow),
                              _buildDiceBtn("D10", 10, clrGreen),
                              _buildDiceBtn("D12", 12, clrBlue),
                              _buildDiceBtn("D20", 20, clrRed),
                              _buildDiceBtn("D%", 100, clrDarkPurple),
                            ],
                          ),

                          const SizedBox(height: 30),

                          // Throw Button
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton.icon(
                              onPressed: _rollAllDice,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: clrDarkButton,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: const Icon(
                                Icons.casino_outlined,
                                color: Colors.white,
                              ),
                              label: const Text(
                                "Throw",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 100), // Space for Navbar
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --- DISINI PEMANGGILAN NAVBAR ---
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomNavbar(
              selectedIndex:
                  1, // Angka 1 artinya menu "Dice" sedang aktif (putih)
              onTap: _onNavbarTapped,
            ),
          ),
        ],
      ),
    );
  }

  // ... (Widget Helpers: _buildDiceBtn, _buildDynamicShape, PolygonPainter TETAP SAMA) ...
  // Copy paste bagian bawahnya dari kode sebelumnya ya, biar gak kepanjangan di sini.

  Widget _buildDiceBtn(String label, int sides, Color color) {
    return InkWell(
      onTap: () => _addDie(label, sides, color),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 80,
        height: 45,
        decoration: BoxDecoration(
          color: const Color(0xFF755C52).withOpacity(0.9),
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicShape(ActiveDie die) {
    int shapeSides = 0;
    if (die.sides == 4)
      shapeSides = 3;
    else if (die.sides == 6)
      shapeSides = 4;
    else if (die.sides == 8)
      shapeSides = 5;
    else if (die.sides == 10 || die.sides == 20)
      shapeSides = 6;
    else
      shapeSides = 0;
    String displayText = die.hasRolled ? "${die.currentValue}" : die.label;

    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (shapeSides == 0)
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: die.color,
                shape: BoxShape.circle,
              ),
            )
          else if (shapeSides == 4)
            Container(width: 50, height: 50, color: die.color)
          else
            CustomPaint(
              size: const Size(55, 55),
              painter: PolygonPainter(sides: shapeSides, color: die.color),
            ),
          Text(
            displayText,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class PolygonPainter extends CustomPainter {
  final int sides;
  final Color color;
  PolygonPainter({required this.sides, required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    var angle = (pi * 2) / sides;
    Offset startPoint = Offset(
      center.dx + radius * cos(-pi / 2),
      center.dy + radius * sin(-pi / 2),
    );
    path.moveTo(startPoint.dx, startPoint.dy);
    for (int i = 1; i <= sides; i++) {
      double x = center.dx + radius * cos(-pi / 2 + angle * i);
      double y = center.dy + radius * sin(-pi / 2 + angle * i);
      path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
