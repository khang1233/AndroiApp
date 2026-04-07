import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'result_screen.dart';

class DetailsScreen extends StatefulWidget {
  final String mood;
  const DetailsScreen({super.key, required this.mood});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final TextEditingController _budgetController = TextEditingController();
  
  String _selectedDuration = "Trong ngày";
  final List<Map<String, String>> _durations = [
    {"label": "Trong ngày", "icon": "☀️"},
    {"label": "1 ngày 1 đêm", "icon": "🌙"},
    {"label": "Nhiều ngày", "icon": "🏕️"}
  ];

  String _selectedLocation = "Biển";
  final List<Map<String, String>> _locations = [
    {"label": "Biển", "icon": "🏖️"},
    {"label": "Núi", "icon": "⛰️"},
    {"label": "Thành phố", "icon": "🏙️"}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Stack(
        children: [
          // Top mood gradient (matching Vui Vẻ screenshot)
          Container(
            height: 250,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFFFFAE70), Color(0xFFFFCC70)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.1), shape: BoxShape.circle),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.mood == "Vui vẻ & Hào hứng" ? "🥳" : "✨", 
                    style: const TextStyle(fontSize: 40)
                  ),
                  const SizedBox(height: 8),
                  Text("Tâm trạng: ${widget.mood}", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const Text("Giờ hãy tùy chỉnh chuyến đi nhé!", style: TextStyle(color: Colors.white, fontSize: 16)),
                ],
              ),
            ),
          ),
          // Scrollable content area
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height - 220,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitle(Icons.credit_card, "Kinh phí dự kiến"),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _budgetController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        _ThousandsFormatter(),
                      ],
                      decoration: InputDecoration(
                        hintText: "Nhập kinh phí (vd: 5.000.000)",
                        hintStyle: const TextStyle(color: Colors.black26),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.black26)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.black26)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildTitle(Icons.access_time, "Thời gian chuyến đi"),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _durations.map((d) => _buildChip(d['label']!, d['icon']!, _selectedDuration, (v) => setState(() => _selectedDuration = v))).toList(),
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildTitle(Icons.search, "Nơi bạn muốn đến"),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _locations.map((d) => _buildChip(d['label']!, d['icon']!, _selectedLocation, (v) => setState(() => _selectedLocation = v))).toList(),
                      ),
                    ),
                    const SizedBox(height: 48),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFFFFAE70), Color(0xFFF96666)]),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: const Color(0xFFF96666).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ResultScreen(mood: widget.mood, budget: _budgetController.text, duration: _selectedDuration, location: _selectedLocation),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent, // Let container dictate gradient
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.search, size: 20),
                        label: const Text("Tìm chuyến đi hoàn hảo", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.red[400], size: 24),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
      ],
    );
  }

  Widget _buildChip(String label, String emoji, String selectedValue, Function(String) onSelect) {
    bool isSel = label == selectedValue;
    return GestureDetector(
      onTap: () => onSelect(label),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSel ? const Color(0xFFE57373) : Colors.white, // Red tone for selection
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isSel ? Colors.transparent : Colors.black12),
          boxShadow: isSel ? [BoxShadow(color: const Color(0xFFE57373).withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))] : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: isSel ? Colors.white : Colors.black87, fontWeight: isSel ? FontWeight.w600 : FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}

class _ThousandsFormatter extends TextInputFormatter {
  static const separator = '.';

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;
    final int selectionIndexFromRight = newValue.text.length - newValue.selection.end;
    final String clean = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (clean.isEmpty) return newValue.copyWith(text: '');
    String result = '';
    for (int i = 0; i < clean.length; i++) {
      if (i > 0 && (clean.length - i) % 3 == 0) {
        result += separator;
      }
      result += clean[i];
    }
    
    int newOffset = result.length - selectionIndexFromRight;
    if (newOffset < 0) newOffset = 0;
    
    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: newOffset),
    );
  }
}
