import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'dart:io' show Platform;

import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatMember {
  final String id;
  final String name;
  final String role;
  final String initial;
  final Color avatarColor;
  final String? avatarUrl;

  const ChatMember({
    required this.id,
    required this.name,
    required this.role,
    required this.initial,
    required this.avatarColor,
    this.avatarUrl,
  });
}

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String senderRole;
  final String? senderAvatarUrl;
  final Color senderAvatarColor;
  final String initial;
  final String text;
  final DateTime sentAt;
  final bool isMe;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderRole,
    required this.senderAvatarColor,
    required this.initial,
    required this.text,
    required this.sentAt,
    required this.isMe,
    this.senderAvatarUrl,
  });
}

class ChatContact {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  bool isAdded;

  ChatContact({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.isAdded = false,
  });
}



class ChatController extends GetxController {
  final RxList<ChatMember>  members     = <ChatMember>[].obs;
  final RxList<ChatMessage> messages    = <ChatMessage>[].obs;
  final RxList<ChatContact> contacts    = <ChatContact>[].obs;
  final RxBool              isTyping    = false.obs;
  final RxString            typingName  = ''.obs;
  final textController = TextEditingController();
  final scrollController = ScrollController();
  final emailController = TextEditingController();

  // Speech-to-text (mic button)
  final stt.SpeechToText speechToText = stt.SpeechToText();
  final RxBool isListening = false.obs;
  final RxBool isSttAvailable = false.obs;

  static const _myId = 'me';

  static const quickReplies = ['Hello Guys, What\'s up?', 'Hi, Everyone.'];

  @override
  void onInit() {
    super.onInit();
    _seedData();
    _initStt();
  }

  void _seedData() {
    members.assignAll([
      const ChatMember(id: 'm1', name: 'Mike',  role: 'Owner',  initial: 'M', avatarColor: Color(0xFF3B77D4)),
      const ChatMember(id: 'm2', name: 'Siam',  role: 'Editor', initial: 'S', avatarColor: Color(0xFF22C55E)),
      const ChatMember(id: 'm3', name: 'Laura', role: 'Viewer', initial: 'L', avatarColor: Color(0xFFF59E0B)),
    ]);

    contacts.assignAll([
      ChatContact(id: 'c1', name: 'Hasnine Jarir', email: 'hasnine@gmail.com', isAdded: true),
      ChatContact(id: 'c2', name: 'Hasnine Jarir', email: 'hasnine@gmail.com', isAdded: true),
      ChatContact(id: 'c3', name: 'Hasnine Jarir', email: 'hasnine@gmail.com', isAdded: true),
      ChatContact(id: 'c4', name: 'Hasnine Jarir', email: 'hasnine@gmail.com', isAdded: false),
      ChatContact(id: 'c5', name: 'Hasnine Jarir', email: 'hasnine@gmail.com', isAdded: false),
      ChatContact(id: 'c6', name: 'Hasnine Jarir', email: 'hasnine@gmail.com', isAdded: false),
    ]);
  }

  Future<void> _initStt() async {
    try {
      final available = await speechToText.initialize(
        onStatus: (status) {
          debugPrint('STT status: $status');
          if (status == 'notListening' || status == 'done') {
            isListening.value = false;
          }
        },
        onError: (error) {
          debugPrint('STT error: $error');
          isListening.value = false;
        },
      );
      isSttAvailable.value = available;
    } catch (e) {
      debugPrint('STT init failed: $e');
      isSttAvailable.value = false;
    }
  }

  /// Called when the mic button is tapped.
  Future<void> toggleListening() async {
    if (!isSttAvailable.value) {
      await _initStt();
      if (!isSttAvailable.value) {
        Get.snackbar('Unavailable', 'Speech recognition is not available on this device');
        return;
      }
    }

    if (isListening.value) {
      await speechToText.stop();
      isListening.value = false;
      return;
    }

    isListening.value = true;
    await speechToText.listen(
      onResult: (result) {
        textController.text = result.recognizedWords;
        textController.selection = TextSelection.fromPosition(
          TextPosition(offset: textController.text.length),
        );
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
      localeId: 'en_US',
    );
  }

  void seedMessages() {
    final now = DateTime.now();
    messages.assignAll([
      ChatMessage(
        id: 'msg1', senderId: 'm1', senderName: 'Atiq Ahsan', senderRole: 'Owner',
        senderAvatarColor: const Color(0xFF3B77D4), initial: 'A',
        text: 'Hello! Thanks for applying for the UI/UX Designer position. I\'ve reviewed your profile and would like to know more about your experience.',
        sentAt: now.subtract(const Duration(minutes: 10)), isMe: false,
      ),
      ChatMessage(
        id: 'msg2', senderId: 'm2', senderName: 'Khairul Dewan Badsha', senderRole: 'Editor',
        senderAvatarColor: const Color(0xFF22C55E), initial: 'K',
        text: 'Hello! Thanks for applying for the UI/UX Designer position. I\'ve reviewed your profile and would like to know more about your experience.',
        sentAt: now.subtract(const Duration(minutes: 8)), isMe: false,
      ),
      ChatMessage(
        id: 'msg3', senderId: _myId, senderName: 'Me', senderRole: '',
        senderAvatarColor: const Color(0xFFF59E0B), initial: 'S',
        text: 'Hello! Thank you for reaching out. I have 3+ years of experience in UI/UX design.',
        sentAt: now.subtract(const Duration(minutes: 5)), isMe: true,
      ),
    ]);
    _simulateTyping();
  }

  void _simulateTyping() {
    Future.delayed(const Duration(milliseconds: 800), () {
      isTyping.value = true;
      typingName.value = 'Atiq Ahsan';
    });
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    if (isListening.value) {
      speechToText.stop();
      isListening.value = false;
    }
    messages.add(ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: _myId, senderName: 'Me', senderRole: '',
      senderAvatarColor: const Color(0xFFF59E0B), initial: 'S',
      text: text.trim(), sentAt: DateTime.now(), isMe: true,
    ));
    textController.clear();
    isTyping.value = false;
    _scrollToBottom();
  }

  void sendQuickReply(String text) => sendMessage(text);

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void toggleContact(String id) {
    final idx = contacts.indexWhere((c) => c.id == id);
    if (idx == -1) return;
    contacts[idx].isAdded = !contacts[idx].isAdded;
    contacts.refresh();
  }

  List<ChatContact> get addedContacts  => contacts.where((c) => c.isAdded).toList();
  List<ChatContact> get moreContacts   => contacts.where((c) => !c.isAdded).toList();

  String get memberCountLabel => '${members.length} people';

  String _timeLabel(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour < 12 ? 'AM' : 'PM';
    return '$h:$m $ampm';
  }

  String timeFor(ChatMessage msg) => _timeLabel(msg.sentAt);

  @override
  void onClose() {
    textController.dispose();
    scrollController.dispose();
    emailController.dispose();
    speechToText.stop();
    super.onClose();
  }
}