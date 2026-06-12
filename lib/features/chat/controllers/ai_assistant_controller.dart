
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home/controllers/home_controller.dart';
enum ChatMessageType { normal, voiceError }

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final ChatMessageType type;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    this.type = ChatMessageType.normal,
  });
}

class ChatSession {
  final String id;
  final String title;
  final List<ChatMessage> messages;

  const ChatSession({
    required this.id,
    required this.title,
    required this.messages,
  });
}

/// What the assistant is doing right now — drives the transient bubbles
/// (typing dots / "Processing...") and the waveform + mic button.
enum AssistantStatus { idle, listening, processing, typing }

// ---------------------------------------------------------------------------
// Controller
// ---------------------------------------------------------------------------

class AssistantController extends GetxController {
  final messages = <ChatMessage>[].obs;
  final history = <ChatSession>[].obs;

  final status = AssistantStatus.idle.obs;
  final aiEnabled = false.obs;

  final inputController = TextEditingController();
  final scrollController = ScrollController();

  String get userName => GetInstance().isRegistered<HomeController>()
      ? Get.find<HomeController>().userName.value
      : 'Siam';

  bool get hasMessages => messages.isNotEmpty;
  bool get isListening => status.value == AssistantStatus.listening;


  void sendText() {
    final text = inputController.text.trim();
    if (text.isEmpty) return;
    if (status.value != AssistantStatus.idle) return;

    inputController.clear();
    _addMessage(ChatMessage(id: _newId(), text: text, isUser: true));
    _replyTo(text);
  }

  void _replyTo(String userText) async {
    status.value = AssistantStatus.typing;
    _scrollToBottom();

    // TODO: replace this mock with your real AI backend call.
    await Future.delayed(const Duration(milliseconds: 1400));
    if (status.value != AssistantStatus.typing) return; // chat was reset

    _addMessage(ChatMessage(
      id: _newId(),
      text: _mockReply(),
      isUser: false,
    ));
    status.value = AssistantStatus.idle;
  }



  void toggleAssistant() {
    aiEnabled.toggle();
    if (aiEnabled.value) {
      startListening();
    } else {
      status.value = AssistantStatus.idle;
    }
  }

  void onMicTap() {
    if (isListening) {
      stopListening();
    } else if (status.value == AssistantStatus.idle) {
      startListening();
    }
  }

  void startListening() {
    if (status.value != AssistantStatus.idle) return;
    status.value = AssistantStatus.listening;
    // TODO: speechToText.listen(onResult: ...) goes here.
  }

  void stopListening() async {
    if (!isListening) return;
    status.value = AssistantStatus.processing;
    _scrollToBottom();

    // TODO: replace with the real speech_to_text result callback.
    await Future.delayed(const Duration(milliseconds: 1600));
    if (status.value != AssistantStatus.processing) return;

    // Simulate: most attempts succeed, some fail to be recognized.
    final recognized = DateTime.now().millisecond % 4 != 0;
    if (!recognized) {
      status.value = AssistantStatus.idle;
      _addMessage(ChatMessage(
        id: _newId(),
        text:
        "We couldn't clearly understand your speech. Please speak again so the AI can respond properly.",
        isUser: false,
        type: ChatMessageType.voiceError,
      ));
      return;
    }

    const transcript = 'Sure. I mostly use Figma for design, '
        'along with Adobe Illustrator and Photoshop.';
    status.value = AssistantStatus.idle;
    _addMessage(ChatMessage(id: _newId(), text: transcript, isUser: true));
    _replyTo(transcript);
  }



  void newChat() {
    _archiveCurrentChat();
    messages.clear();
    status.value = AssistantStatus.idle;
    aiEnabled.value = false;
  }

  void openChat(ChatSession session) {
    _archiveCurrentChat();
    history.removeWhere((s) => s.id == session.id);
    messages.assignAll(session.messages);
    status.value = AssistantStatus.idle;
    _scrollToBottom();
  }

  void _archiveCurrentChat() {
    if (messages.isEmpty) return;
    final firstUserMsg = messages.firstWhereOrNull((m) => m.isUser);
    history.insert(
      0,
      ChatSession(
        id: _newId(),
        title: (firstUserMsg ?? messages.first).text,
        messages: messages.toList(),
      ),
    );
  }



  void _addMessage(ChatMessage m) {
    messages.add(m);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  int _idCounter = 0;
  String _newId() =>
      '${DateTime.now().millisecondsSinceEpoch}_${_idCounter++}';

  final _cannedReplies = [
    "Hello! Thanks for reaching out. How can I help you with your trip today?",
    "That's great. Can you share a bit more detail?",
    "Got it! I've noted that down for you.",
    "Sure — here's what I'd suggest based on your plans.",
  ];
  int _replyIndex = 0;
  String _mockReply() =>
      _cannedReplies[_replyIndex++ % _cannedReplies.length];

  @override
  void onClose() {
    inputController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}