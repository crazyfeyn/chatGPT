import 'package:flutter_application_1/services/ai_chat_services.dart';

class AiChatControllers {
  final aiChatServices = AiChatServices();

  Future<String> inputQuery(String query) async {
    return aiChatServices.inputQuery(query);
  }
}
