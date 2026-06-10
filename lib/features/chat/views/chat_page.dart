import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/util/screen_size.dart';
import '../../../../core/widgets/text/app_text.dart';
import '../../../core/themes/theme_controller.dart';
import '../controllers/chat_controller.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ChatController>()) {
      Get.put(ChatController());
    }
    final controller = Get.find<ChatController>();

    return Obx(() {
      final tc = GetInstance().isRegistered<ThemeController>()
          ? Get.find<ThemeController>()
          : null;
      tc?.themeMode.value;
      tc?.platformBrightness;

      return Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: SafeArea(
          child: Column(
            children: [
              _ChatHeader(controller: controller),
              Expanded(
                child: Obx(() {
                  if (controller.messages.isEmpty) {
                    return _EmptyChat(controller: controller);
                  }
                  return _MessageList(controller: controller);
                }),
              ),
              _InputBar(controller: controller),
            ],
          ),
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────
//  Header
// ─────────────────────────────────────────────

class _ChatHeader extends StatelessWidget {
  final ChatController controller;
  const _ChatHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(context.w(16), context.h(14), context.w(16), context.h(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: context.sp(22)),
              ),
              SizedBox(width: context.w(10)),
              AppText(data: 'Group Chat', fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ],
          ),
          SizedBox(height: context.h(12)),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(data: controller.memberCountLabel, fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  SizedBox(height: context.h(2)),
                  AppText(data: 'shared coordination', fontSize: 13, color: AppColors.textSecondary),
                ],
              ),
              const Spacer(),
              _AvatarStack(controller: controller),
            ],
          ),
        ],
      ),
    );
  }
}

class _AvatarStack extends StatelessWidget {
  final ChatController controller;
  const _AvatarStack({required this.controller});

  @override
  Widget build(BuildContext context) {
    const overlap = 12.0;
    final avatarSize = context.w(38);
    final members = controller.members;
    final totalWidth = (members.length * (avatarSize - overlap)) + overlap + avatarSize;

    return SizedBox(
      width: totalWidth,
      height: avatarSize,
      child: Stack(
        children: [
          ...members.asMap().entries.map((e) => Positioned(
            left: e.key * (avatarSize - overlap),
            child: _InitialAvatar(
              initial: e.value.initial,
              color: e.value.avatarColor,
              size: avatarSize,
            ),
          )),
          Positioned(
            left: members.length * (avatarSize - overlap),
            child: GestureDetector(
              onTap: () => _showAddPeopleSheet(context, controller),
              child: Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.inputBorder, width: 1.5),
                ),
                child: Icon(Icons.add, color: AppColors.textSecondary, size: context.sp(18)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddPeopleSheet(BuildContext context, ChatController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(context.w(24))),
      ),
      builder: (_) => _AddPeopleSheet(controller: controller),
    );
  }
}

class _InitialAvatar extends StatelessWidget {
  final String initial;
  final Color color;
  final double size;
  const _InitialAvatar({required this.initial, required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.surface, width: 2),
      ),
      alignment: Alignment.center,
      child: AppText(data: initial, fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
    );
  }
}

// ─────────────────────────────────────────────
//  Empty state
// ─────────────────────────────────────────────

class _EmptyChat extends StatelessWidget {
  final ChatController controller;
  const _EmptyChat({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        AppText(data: 'Welcome Siam,', fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
        SizedBox(height: context.h(10)),
        AppText(data: 'Start chat with your friends.', fontSize: 16, color: AppColors.textSecondary),
        const Spacer(),
        _QuickReplies(controller: controller),
        SizedBox(height: context.h(12)),
      ],
    );
  }
}

class _QuickReplies extends StatelessWidget {
  final ChatController controller;
  const _QuickReplies({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: ChatController.quickReplies.map((text) => Padding(
          padding: EdgeInsets.symmetric(horizontal: context.w(6)),
          child: GestureDetector(
            onTap: () {
              controller.seedMessages();
              controller.sendQuickReply(text);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(10)),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(context.w(50)),
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: AppText(data: text, fontSize: 13, color: AppColors.textPrimary),
            ),
          ),
        )).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Message list
// ─────────────────────────────────────────────

class _MessageList extends StatelessWidget {
  final ChatController controller;
  const _MessageList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller.scrollController,
      padding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(12)),
      itemCount: controller.messages.length + (controller.isTyping.value ? 1 : 0),
      itemBuilder: (context, i) {
        if (i == controller.messages.length && controller.isTyping.value) {
          return _TypingIndicator(controller: controller);
        }
        final msg = controller.messages[i];
        return msg.isMe
            ? _MyBubble(msg: msg, controller: controller)
            : _OtherBubble(msg: msg, controller: controller);
      },
    );
  }
}

class _OtherBubble extends StatelessWidget {
  final ChatMessage msg;
  final ChatController controller;
  const _OtherBubble({required this.msg, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.h(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: context.w(52), bottom: context.h(6)),
            child: AppText(
              data: '${msg.senderName} - ${msg.senderRole}',
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(width: context.w(52)),
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(14)),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.only(
                      topLeft:     Radius.circular(context.w(16)),
                      topRight:    Radius.circular(context.w(16)),
                      bottomRight: Radius.circular(context.w(16)),
                      bottomLeft:  Radius.circular(context.w(4)),
                    ),
                    border: Border.all(color: AppColors.inputBorder),
                  ),
                  child: AppText(data: msg.text, fontSize: 15, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: context.h(6)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _InitialAvatar(initial: msg.initial, color: msg.senderAvatarColor, size: context.w(34)),
                SizedBox(width: context.w(10)),
                AppText(data: controller.timeFor(msg), fontSize: 11, color: AppColors.textSecondary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MyBubble extends StatelessWidget {
  final ChatMessage msg;
  final ChatController controller;
  const _MyBubble({required this.msg, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.h(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(right: context.w(52), bottom: context.h(6)),
            child: AppText(data: 'Me', fontSize: 12, color: AppColors.textSecondary),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(14)),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(
                      topLeft:     Radius.circular(context.w(16)),
                      topRight:    Radius.circular(context.w(16)),
                      bottomLeft:  Radius.circular(context.w(16)),
                      bottomRight: Radius.circular(context.w(4)),
                    ),
                  ),
                  child: AppText(data: msg.text, fontSize: 15, color: Colors.white),
                ),
              ),
              SizedBox(width: context.w(10)),
              SizedBox(width: context.w(34)),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: context.h(6)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppText(data: controller.timeFor(msg), fontSize: 11, color: AppColors.textSecondary),
                SizedBox(width: context.w(10)),
                _InitialAvatar(initial: msg.initial, color: msg.senderAvatarColor, size: context.w(34)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  final ChatController controller;
  const _TypingIndicator({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.h(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _InitialAvatar(
            initial: controller.members.isNotEmpty ? controller.members.first.initial : '?',
            color: controller.members.isNotEmpty ? controller.members.first.avatarColor : AppColors.primary,
            size: context.w(34),
          ),
          SizedBox(width: context.w(10)),
          Container(
            padding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(14)),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(context.w(16)),
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) => Container(
                margin: EdgeInsets.symmetric(horizontal: context.w(3)),
                width: context.w(8),
                height: context.w(8),
                decoration: BoxDecoration(color: AppColors.textSecondary.withOpacity(0.5), shape: BoxShape.circle),
              )),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Input bar
// ─────────────────────────────────────────────

class _InputBar extends StatelessWidget {
  final ChatController controller;
  const _InputBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(context.w(12), context.h(10), context.w(12), context.h(16)),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        border: Border(top: BorderSide(color: AppColors.inputBorder)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              width: context.w(46),
              height: context.w(46),
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: Icon(Icons.mic_none_outlined, color: AppColors.primary, size: context.sp(22)),
            ),
          ),
          SizedBox(width: context.w(10)),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: context.w(16)),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(context.w(50)),
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: TextField(
                controller: controller.textController,
                style: TextStyle(fontSize: context.sp(15), color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Type Here...',
                  hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: context.sp(15)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: context.h(12)),
                ),
                onSubmitted: (v) => controller.sendMessage(v),
              ),
            ),
          ),
          SizedBox(width: context.w(10)),
          GestureDetector(
            onTap: () => controller.sendMessage(controller.textController.text),
            child: Container(
              width: context.w(46),
              height: context.w(46),
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: Icon(Icons.send_outlined, color: AppColors.primary, size: context.sp(20)),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Add People bottom sheet
// ─────────────────────────────────────────────

class _AddPeopleSheet extends StatelessWidget {
  final ChatController controller;
  const _AddPeopleSheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, scrollCtrl) => Padding(
        padding: EdgeInsets.fromLTRB(context.w(20), context.h(24), context.w(20), 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(data: 'Add People', fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            SizedBox(height: context.h(4)),
            AppText(data: 'Select from dropdown to add friends', fontSize: 14, color: AppColors.textSecondary),
            SizedBox(height: context.h(20)),
            Expanded(
              child: Obx(() => ListView(
                controller: scrollCtrl,
                children: [
                  if (controller.addedContacts.isNotEmpty) ...[
                    AppText(data: 'Added', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    SizedBox(height: context.h(12)),
                    ...controller.addedContacts.map((c) => _ContactRow(contact: c, controller: controller)),
                    SizedBox(height: context.h(20)),
                  ],
                  if (controller.moreContacts.isNotEmpty) ...[
                    AppText(data: 'Add More People', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    SizedBox(height: context.h(12)),
                    ...controller.moreContacts.map((c) => _ContactRow(contact: c, controller: controller)),
                    SizedBox(height: context.h(20)),
                  ],
                  AppText(data: 'Email Addess', fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  SizedBox(height: context.h(10)),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.inputBorder),
                      borderRadius: BorderRadius.circular(context.w(12)),
                    ),
                    child: TextField(
                      controller: controller.emailController,
                      style: TextStyle(fontSize: context.sp(15), color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Rhebhek@gmail.com',
                        hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: context.sp(15)),
                        contentPadding: EdgeInsets.symmetric(horizontal: context.w(16), vertical: context.h(14)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: context.h(20)),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: context.h(16)),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(context.w(50)),
                      ),
                      alignment: Alignment.center,
                      child: AppText(data: 'Save', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: context.h(32)),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final ChatContact contact;
  final ChatController controller;
  const _ContactRow({required this.contact, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.h(10)),
      padding: EdgeInsets.symmetric(horizontal: context.w(14), vertical: context.h(12)),
      decoration: BoxDecoration(
        color: AppColors.scaffoldBg,
        borderRadius: BorderRadius.circular(context.w(14)),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Row(
        children: [
          ClipOval(
            child: contact.avatarUrl != null
                ? Image.network(contact.avatarUrl!, width: context.w(44), height: context.w(44), fit: BoxFit.cover)
                : Container(
                    width: context.w(44),
                    height: context.w(44),
                    color: AppColors.inputBorder,
                    child: Icon(Icons.person_outline, color: AppColors.textSecondary, size: context.sp(22)),
                  ),
          ),
          SizedBox(width: context.w(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(data: contact.name, fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                SizedBox(height: context.h(2)),
                AppText(data: contact.email, fontSize: 13, color: AppColors.textSecondary),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => controller.toggleContact(contact.id),
            child: Container(
              width: context.w(28),
              height: context.w(28),
              decoration: BoxDecoration(
                color: contact.isAdded ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(context.w(6)),
                border: Border.all(
                  color: contact.isAdded ? AppColors.primary : AppColors.inputBorder,
                  width: 1.5,
                ),
              ),
              child: contact.isAdded
                  ? Icon(Icons.check, color: Colors.white, size: context.sp(16))
                  : Icon(Icons.check, color: AppColors.inputBorder, size: context.sp(16)),
            ),
          ),
        ],
      ),
    );
  }
}
