import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  const String apiKey = "AIzaSyBjn1JuS5R3DP8EDibdiYd8eYoNzrNjLv4";
  const String model = "gemini-2.5-flash";
  final url = Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/\$model:generateContent?key=\$apiKey");
  final prompt = "Trả lời ngắn: Xin chào!";
  
  try {
    print("Testing API...");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contents": [{"parts": [{"text": prompt}]}]
      }),
    );
    print("Status: \${response.statusCode}");
    if (response.statusCode == 200) {
       final data = jsonDecode(utf8.decode(response.bodyBytes));
       print("Reply: \${data['candidates'][0]['content']['parts'][0]['text']}");
    } else {
       print("Body: \${response.body}");
    }
  } catch (e) {
    print("Error: \$e");
  }
}
