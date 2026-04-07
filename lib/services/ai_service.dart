import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  // 👉 DÁN API KEY MỚI VÀO ĐÂY
  static const String _apiKey = "AIzaSyBjn1JuS5R3DP8EDibdiYd8eYoNzrNjLv4";

  static const String _model = "gemini-2.5-flash";

  Future<String> generateIntro(String placeName) async {
    final String prompt = """
Hãy trả lời hoàn toàn bằng Tiếng Việt. Bạn là một hướng dẫn viên du lịch ảo thân thiện.
Hãy viết một đoạn giới thiệu chi tiết, dài khoảng 50 - 70 chữ về điểm đến: $placeName.
Bắt buộc liệt kê 3 đặc sản địa phương ngon nhất và 3 địa điểm đáng tham quan nhất ở đây.
Văn phong vui vẻ, cuốn hút, đọc là muốn xách balo lên và đi!
""";

    return await _callGeminiAndReturnString(prompt, placeName, true);
  }

  Future<String> generateItinerary(String placeName,
      {String budget = "", String duration = "", String mood = ""}) async {
    final String prompt = """
Hãy trả lời hoàn toàn bằng Tiếng Việt. Bạn là một AI Gen Z thiết kế tour du lịch thông minh, thân thiện.
Thiết kế lịch trình cực xịn cho điểm đến: $placeName.
- Tâm trạng: ${mood.isNotEmpty ? mood : 'Vui vẻ'}
- Thời gian: ${duration.isNotEmpty ? duration : 'Linh hoạt'}
- Ngân sách tổng: ${budget.isNotEmpty ? budget : 'Tùy tâm'}

Trả về nguyên văn ĐÚNG FORMAT JSON DƯỚI ĐÂY (không bọc text, không markdown):
{
  "intro": "1 đoạn văn nói chuyện kiểu Gen Z an ủi/động viên cực hay dựa theo đúng Tâm trạng và số Ngân Sách mà khách đưa. Ví dụ: 'Tâm trạng Buồn hả? Ok, có 10 triệu đi Đà Lạt là dư xài luôn 😎...'",
  "itinerary": [
    {
      "day": "Ví dụ: Ngày 1 (Luôn bắt đầu từ Ngày 1, tuyệt đối không dùng Ngày 0)",
      "time": "Ví dụ: Sáng",
      "title": "Tên hoạt động ngắn",
      "desc": "Mô tả review chi tiết chỗ ăn/chơi",
      "cost": "~300k"
    }
  ],
  "costBreakdown": [
    {"label": "✈ Di chuyển", "percentage": "30%", "amount": "7.000.000 đ"},
    {"label": "🍜 Ăn uống", "percentage": "40%", "amount": "7.300.000 đ"},
    {"label": "🎟 Hoạt động", "percentage": "30%", "amount": "15.000.000 đ"}
  ],
  "totalCost": "Tổng chi phí tối ưu: XX.XXX.000 đ"
}
""";

    return await _callGeminiAndReturnString(prompt, placeName, false);
  }

  Future<String> _callGeminiAndReturnString(
      String prompt, String placeName, bool isIntro) async {
    try {
      // 👉 chống spam API (fix lỗi 429)
      await Future.delayed(const Duration(milliseconds: 800));

      final url = Uri.parse(
        "https://generativelanguage.googleapis.com/v1beta/models/$_model:generateContent?key=$_apiKey",
      );

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ],
          "generationConfig": {
            "temperature": 0.7,
            "maxOutputTokens": 8192,
            "response_mime_type": isIntro ? "text/plain" : "application/json"
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return (data['candidates'][0]['content']['parts'][0]['text'] as String)
            .trim();
      } else {
        throw Exception("Lỗi API - Status: " + response.statusCode.toString() + " - Body: " + response.body);
      }
    } catch (e) {
      print("AI Error: $e");
      return isIntro
          ? _getIntroFallback(placeName, e.toString())
          : _getItineraryFallback(placeName, e.toString());
    }
  }

  String _getIntroFallback(String placeName, String errorMsg) {
    return "👉 [LỖI API]: $errorMsg\n\n$placeName là một điểm đến tuyệt vời, đáng để khám phá!";
  }

  String _getItineraryFallback(String placeName, String errorMsg) {
    final cleanErr =
        errorMsg.replaceAll('\n', ' ').replaceAll('"', '\\"');
    return '''
{
  "intro": "👉 [LỖI API]: $cleanErr",
  "itinerary": [
    {
      "day": "Ngày 1",
      "time": "Sáng",
      "title": "Dạo quanh",
      "desc": "Khám phá trung tâm",
      "cost": "~500k"
    }
  ],
  "totalCost": "~500k"
}
''';
  }
}