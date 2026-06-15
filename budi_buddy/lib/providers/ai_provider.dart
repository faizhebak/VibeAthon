import 'package:flutter/material.dart';

import '../core/mock_data.dart';

class AIMessage {
  const AIMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
  });

  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
}

class AIProvider extends ChangeNotifier {
  final List<AIMessage> _messages = [];
  bool _isTyping = false;
  bool _insightsLoaded = false;

  List<AIMessage> get messages => List.unmodifiable(_messages);

  bool get isTyping => _isTyping;

  bool get insightsLoaded => _insightsLoaded;

  Future<void> loadInsights() async {
    if (_insightsLoaded) return;

    _isTyping = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1500));

    _insightsLoaded = true;
    _isTyping = false;
    _messages.add(
      AIMessage(
        id: 'msg_welcome',
        content:
            "Hi! I've reviewed your Perodua Myvi's fuel records and driving data for this month and prepared 3 insights above. Tap any of them for more detail, or ask me a question below.",
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  Future<void> sendMessage(String userMessage) async {
    if (userMessage.trim().isEmpty) return;

    _messages.add(
      AIMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        content: userMessage,
        isUser: true,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();

    _isTyping = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1500));

    final response =
        MockData.aiResponses[userMessage] ?? MockData.aiFallbackResponse;

    _messages.add(
      AIMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch + 1}',
        content: response,
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );

    _isTyping = false;
    notifyListeners();
  }

  void clearMessages() {
    _messages.clear();
    _isTyping = false;
    notifyListeners();
  }

  void resetInsights() {
    _insightsLoaded = false;
    notifyListeners();
  }
}
