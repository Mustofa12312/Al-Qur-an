import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class TasbihTab extends StatefulWidget {
  const TasbihTab({super.key});

  @override
  State<TasbihTab> createState() => _TasbihTabState();
}

class _TasbihTabState extends State<TasbihTab> {
  int counter = 0;
  int target = 33;
  bool vibration = true;

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_onKeyEvent);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKeyEvent);
    super.dispose();
  }

  bool _onKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.audioVolumeUp) {
        increment();
        return true;
      }
      if (event.logicalKey == LogicalKeyboardKey.audioVolumeDown) {
        decrement();
        return true;
      }
    }
    return false;
  }

  void increment() async {
    setState(() => counter++);

    if (vibration) HapticFeedback.mediumImpact();

    if (counter == target) {
      for (int i = 0; i < 3; i++) {
        HapticFeedback.heavyImpact();
        await Future.delayed(const Duration(milliseconds: 150));
      }
    }

    if (counter >= 9999) counter = 0;
  }

  void decrement() {
    if (counter > 0) {
      setState(() => counter--);
      if (vibration) HapticFeedback.selectionClick();
    }
  }

  void reset() {
    setState(() => counter = 0);
    HapticFeedback.heavyImpact();
  }

  void showTargetSheet() {
    final controller = TextEditingController(text: target.toString());

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161C2E),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Ubah Target Tasbih",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Masukkan target",
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: const Color(0xFF1E2740),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    target = int.tryParse(controller.text) ?? target;
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9055FF),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
                ),
                child: const Text("Simpan"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              Text(
                "Digital Tasbih",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              GestureDetector(
                onTap: showTargetSheet,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C2438),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "🎯 Target: $target (ubah)",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: const Color(0xFF171F32),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.4),
                      blurRadius: 25,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Text(
                  "$counter",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 65,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              GestureDetector(
                onTap: increment,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 165,
                  height: 165,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9A4BFF), Color(0xFF5E00FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.5),
                        blurRadius: 40,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add, size: 80, color: Colors.white),
                ),
              ),

              const SizedBox(height: 40),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: reset,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Reset"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Row(
                    children: [
                      const Text(
                        "Getar",
                        style: TextStyle(color: Colors.white),
                      ),
                      Switch(
                        value: vibration,
                        activeColor: Colors.greenAccent,
                        onChanged: (v) => setState(() => vibration = v),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Text(
                "Gunakan tombol volume untuk menambah atau mengurangi.",
                style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
