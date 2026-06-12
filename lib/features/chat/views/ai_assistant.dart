import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/themes/theme_controller.dart';
import '../../../core/util/screen_size.dart';
import '../../../core/widgets/text/app_text.dart';
import '../controllers/ai_assistant_controller.dart';
class AssistantPage extends StatefulWidget {
  const AssistantPage({super.key});

  @override
  State<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends State<AssistantPage> {
  late final AssistantController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(AssistantController());
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Reactive deps for the whole page.
      controller.messages.length;
      controller.status.value;
      controller.aiEnabled.value;

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
              _TopBar(controller: controller),
              Expanded(
                child: controller.hasMessages
                    ? _MessageList(controller: controller)
                    : _WelcomeView(controller: controller),
              ),
              _InputBar(controller: controller),
            ],
          ),
        ),
      );
    });
  }
}

// ---------------------------------------------------------------------------
// Top bar
// ---------------------------------------------------------------------------

class _TopBar extends StatelessWidget {
  final AssistantController controller;
  const _TopBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.w(20),
        context.h(12),
        context.w(20),
        context.h(8),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.textPrimary,
              size: context.sp(22),
            ),
          ),
          SizedBox(width: context.w(16)),
          Expanded(
            child: AppText(
              data: 'Assistant',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          GestureDetector(
            onTap: () => _showHistory(context),
            child: Icon(
              Icons.history,
              color: AppColors.textPrimary,
              size: context.sp(26),
            ),
          ),
        ],
      ),
    );
  }

  void _showHistory(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.35),
      builder: (_) => Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: EdgeInsets.only(
            top: context.h(64),
            right: context.w(16),
          ),
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: context.w(260),
              padding: EdgeInsets.all(context.w(16)),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(context.w(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Obx(() {
                final sessions = controller.history;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppText(
                      data: 'History',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.center,
                      color: AppColors.textPrimary,
                    ),
                    SizedBox(height: context.h(12)),
                    if (sessions.isEmpty)
                      Padding(
                        padding:
                        EdgeInsets.symmetric(vertical: context.h(8)),
                        child: AppText(
                          data: 'No previous chats',
                          fontSize: 13,
                          textAlign: TextAlign.center,
                          color: AppColors.textSecondary,
                        ),
                      )
                    else
                      ConstrainedBox(
                        constraints:
                        BoxConstraints(maxHeight: context.h(260)),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: sessions.length,
                          separatorBuilder: (_, __) =>
                              SizedBox(height: context.h(14)),
                          itemBuilder: (_, i) {
                            final s = sessions[i];
                            return GestureDetector(
                              onTap: () {
                                Get.back(); // close dialog
                                controller.openChat(s);
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Row(
                                children: [
                                  Container(
                                    width: context.w(24),
                                    height: context.w(24),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF1F2937),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.chat_bubble,
                                      size: context.sp(12),
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: context.w(10)),
                                  Expanded(
                                    child: AppText(
                                      data: s.title,
                                      fontSize: 14,
                                      maxLines: 1,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    SizedBox(height: context.h(16)),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                        controller.newChat();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: context.h(12)),
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(context.w(10)),
                          border: Border.all(
                            color: AppColors.textPrimary,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: AppText(
                          data: '+ New Chat',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.center,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Welcome (empty) state
// ---------------------------------------------------------------------------

class _WelcomeView extends StatelessWidget {
  final AssistantController controller;
  const _WelcomeView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: context.h(120)),
        AppText(
          data: 'Welcome ${controller.userName},',
          fontSize: 32,
          fontWeight: FontWeight.w800,
          textAlign: TextAlign.center,
          color: AppColors.textPrimary,
        ),
        SizedBox(height: context.h(8)),
        AppText(
          data: 'What would you like to remember?',
          fontSize: 18,
          fontWeight: FontWeight.w400,
          textAlign: TextAlign.center,
          color: AppColors.inputHint,
        ),
        SizedBox(height: context.h(80)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              data: 'AI Assistant',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
            SizedBox(width: context.w(10)),
            Obx(() => GestureDetector(
              onTap: controller.toggleAssistant,
              child: Icon(
                controller.aiEnabled.value
                    ? Icons.toggle_on
                    : Icons.toggle_off_outlined,
                size: context.sp(38),
                color: controller.aiEnabled.value
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            )),
          ],
        ),
        SizedBox(height: context.h(10)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.w(40)),
          child: AppText(
            data:
            'Turn it on and start getting instant help, answers, and smart support anytime.',
            fontSize: 14,
            textAlign: TextAlign.center,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: context.h(40)),
        Obx(() => controller.isListening
            ? _Waveform(height: context.h(90))
            : SizedBox(height: context.h(90))),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Message list + bubbles
// ---------------------------------------------------------------------------

class _MessageList extends StatelessWidget {
  final AssistantController controller;
  const _MessageList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final status = controller.status.value;
      final showStatusBubble = status == AssistantStatus.typing ||
          status == AssistantStatus.processing;
      final showWave = status == AssistantStatus.listening;

      final itemCount = controller.messages.length +
          (showStatusBubble ? 1 : 0) +
          (showWave ? 1 : 0);

      return ListView.builder(
        controller: controller.scrollController,
        padding: EdgeInsets.fromLTRB(
          context.w(20),
          context.h(12),
          context.w(20),
          context.h(12),
        ),
        itemCount: itemCount,
        itemBuilder: (_, i) {
          if (i < controller.messages.length) {
            return _MessageBubble(message: controller.messages[i]);
          }
          if (showWave) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: context.h(12)),
              child: _Waveform(height: context.h(70)),
            );
          }
          return status == AssistantStatus.typing
              ? const _TypingBubble()
              : const _ProcessingBubble();
        },
      );
    });
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.type == ChatMessageType.voiceError) {
      return _VoiceErrorBubble(text: message.text);
    }

    final isUser = message.isUser;
    final maxWidth = MediaQuery.of(context).size.width * 0.74;

    final bubble = Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: EdgeInsets.symmetric(
        horizontal: context.w(16),
        vertical: context.h(12),
      ),
      decoration: BoxDecoration(
        color: isUser ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(context.w(18)),
          topRight: Radius.circular(context.w(18)),
          bottomLeft: Radius.circular(isUser ? context.w(18) : context.w(4)),
          bottomRight: Radius.circular(isUser ? context.w(4) : context.w(18)),
        ),
        border: isUser ? null : Border.all(color: AppColors.inputBorder),
      ),
      child: AppText(
        data: message.text,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: isUser ? AppColors.textOnPrimary : AppColors.textPrimary,
      ),
    );

    return Padding(
      padding: EdgeInsets.only(bottom: context.h(14)),
      child: Row(
        mainAxisAlignment:
        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isUser) ...[
            Flexible(child: bubble),
            SizedBox(width: context.w(6)),
            // Swap for the real profile photo when available.
            CircleAvatar(
              radius: context.w(13),
              backgroundColor: AppColors.iconBg,
              child: Icon(
                Icons.person,
                size: context.sp(15),
                color: AppColors.iconColor,
              ),
            ),
          ] else
            Flexible(child: bubble),
        ],
      ),
    );
  }
}

class _VoiceErrorBubble extends StatelessWidget {
  final String text;
  const _VoiceErrorBubble({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.h(14)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(context.w(14)),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.07),
          borderRadius: BorderRadius.circular(context.w(14)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              data: "Couldn't understand your voice",
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.error,
            ),
            SizedBox(height: context.h(4)),
            AppText(
              data: text,
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(18),
          vertical: context.h(14),
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(context.w(16)),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: const _PulsingDots(),
      ),
    );
  }
}

class _ProcessingBubble extends StatelessWidget {
  const _ProcessingBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(context.w(14)),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(context.w(14)),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              data: 'Processing...',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            SizedBox(height: context.h(4)),
            AppText(
              data: 'AI is understanding your voice.',
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Input bar
// ---------------------------------------------------------------------------

class _InputBar extends StatelessWidget {
  final AssistantController controller;
  const _InputBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.w(16),
        context.h(8),
        context.w(16),
        context.h(16),
      ),
      child: Row(
        children: [
          Obx(() => GestureDetector(
            onTap: controller.onMicTap,
            child: Container(
              width: context.w(52),
              height: context.w(52),
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                controller.isListening ? Icons.close : Icons.mic_none,
                size: context.sp(24),
                color: controller.isListening
                    ? AppColors.textPrimary
                    : AppColors.primary,
              ),
            ),
          )),
          SizedBox(width: context.w(10)),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: context.w(16)),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(context.w(26)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.inputController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => controller.sendText(),
                      style: GoogleFonts.inter(
                        fontSize: context.sp(15),
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type Here...',
                        hintStyle: GoogleFonts.inter(
                          color: AppColors.inputHint,
                          fontSize: context.sp(15),
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: context.h(16),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: controller.sendText,
                    child: Icon(
                      Icons.send,
                      size: context.sp(20),
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Animated bits
// ---------------------------------------------------------------------------

/// Looping voice waveform made of vertical bars.
class _Waveform extends StatefulWidget {
  final double height;
  const _Waveform({required this.height});

  @override
  State<_Waveform> createState() => _WaveformState();
}

class _WaveformState extends State<_Waveform>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  static const _barCount = 48;
  late final List<double> _seeds;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    final rnd = math.Random(7);
    _seeds = List.generate(_barCount, (_) => rnd.nextDouble());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return SizedBox(
          height: widget.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(_barCount, (i) {
              final phase = _controller.value * 2 * math.pi;
              final h = (0.25 +
                  0.75 *
                      (0.5 +
                          0.5 *
                              math.sin(phase + _seeds[i] * 2 * math.pi)) *
                      _seeds[i]) *
                  widget.height;
              return Container(
                width: 3,
                height: h.clamp(6, widget.height),
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

/// Three pulsing dots for the typing indicator.
class _PulsingDots extends StatefulWidget {
  const _PulsingDots();

  @override
  State<_PulsingDots> createState() => _PulsingDotsState();
}

class _PulsingDotsState extends State<_PulsingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final t = (_controller.value + i * 0.2) % 1.0;
            final opacity = 0.3 + 0.7 * (1 - (t - 0.5).abs() * 2).clamp(0, 1);
            return Container(
              width: 7,
              height: 7,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withOpacity(opacity.toDouble()),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}