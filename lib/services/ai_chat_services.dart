import 'package:google_generative_ai/google_generative_ai.dart';

class AiChatServices {
  Future<String> inputQuery(String query) async {
    print("-------------------------$query");
    final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: "AIzaSyAwR41Sh6OSCZc5812UiO0puC3q4XmtAqg");
    final content = [Content.text("$query?")];
    final response = await model.generateContent(content);
    return response.text!;
  }
}
