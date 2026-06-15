import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../core/mock_data.dart';
import '../../core/router.dart';
import '../../providers/ai_provider.dart';
import '../../widgets/ai/ai_bubble.dart';
import '../../widgets/ai/insight_card.dart';
import '../../widgets/ai/prompt_chip_row.dart';
import '../../widgets/common/premium_banner.dart';

class AIScreen extends StatefulWidget {
  const AIScreen({super.key});

  @override
  State<AIScreen> createState() => _AIScreenState();
}

class _AIScreenState extends State<AIScreen> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late final List<AnimationController> _cardControllers;

  static const List<int> _cardDelaysMs = [1600, 2000, 2400];

  @override
  void initState() {
    super.initState();

    _cardControllers = List.generate(
      3,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400),
      ),
    );

    context.read<AIProvider>().loadInsights().then((_) => _scrollToBottom());

    _startCardAnimations();
  }

  void _startCardAnimations() {
    for (var i = 0; i < _cardControllers.length; i++) {
      Future.delayed(Duration(milliseconds: _cardDelaysMs[i]), () {
        if (mounted) _cardControllers[i].forward(from: 0);
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    for (final controller in _cardControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _handleSend([String? promptText]) {
    final message = (promptText ?? _textController.text).trim();
    if (message.isEmpty) return;

    _textController.clear();
    _scrollToBottom();
    context.read<AIProvider>().sendMessage(message).then((_) {
      _scrollToBottom();
    });
  }

  void _handleReset() {
    final aiProvider = context.read<AIProvider>();
    aiProvider.clearMessages();
    aiProvider.resetInsights();

    for (final controller in _cardControllers) {
      controller.reset();
    }

    aiProvider.loadInsights().then((_) => _scrollToBottom());
    _startCardAnimations();
  }

  @override
  Widget build(BuildContext context) {
    final aiProvider = context.watch<AIProvider>();
    final insights = MockData.aiInsights;
    final aiResponseCount = aiProvider.messages
        .where((message) => !message.isUser)
        .length;

    return Scaffold(
      backgroundColor: kNeutralBg,
      appBar: AppBar(
        backgroundColor: kPrimaryGreen,
        elevation: 0,
        title: Text(
          'BudiBuddy AI',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: kWhite,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: kWhite),
            tooltip: 'Reset conversation',
            onPressed: _handleReset,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(kSpaceMD, kSpaceMD, kSpaceMD, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionLabel(text: 'Your Insights'),
                const SizedBox(height: kSpaceSM),
                if (!aiProvider.insightsLoaded)
                  Column(
                    children: const [
                      _InsightSkeleton(),
                      SizedBox(height: kSpaceSM),
                      _InsightSkeleton(),
                      SizedBox(height: kSpaceSM),
                      _InsightSkeleton(),
                    ],
                  )
                else
                  Column(
                    children: [
                      for (
                        var i = 0;
                        i < insights.length && i < _cardControllers.length;
                        i++
                      )
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: i == insights.length - 1 ? 0 : kSpaceSM,
                          ),
                          child: FadeTransition(
                            opacity: _cardControllers[i],
                            child: InsightCard(
                              insight: insights[i],
                              onTap: () => context.push(
                                '${RoutePaths.insightDetail}/${insights[i]['id']}',
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: kSpaceSM),
          const Divider(color: kSurfaceGreen, height: 1),
          Expanded(
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(kSpaceMD),
              children: [
                for (final message in aiProvider.messages)
                  AIBubble(message: message),
                if (aiProvider.isTyping && aiProvider.insightsLoaded)
                  const _TypingIndicator(),
                if (aiResponseCount >= 3) ...[
                  const SizedBox(height: kSpaceSM),
                  const PremiumBanner(
                    title: 'Unlock Full AI Coaching',
                    description:
                        'Get unlimited personalised insights, weekly coaching reports, and proactive refuel alerts with BudiBuddy Premium.',
                  ),
                ],
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: kWhite,
              border: Border(top: BorderSide(color: kSurfaceGreen)),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: kSpaceMD,
              vertical: kSpaceSM,
            ),
            child: SafeArea(
              top: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (aiProvider.insightsLoaded) ...[
                    PromptChipRow(
                      prompts: MockData.suggestedPrompts,
                      onSelect: _handleSend,
                    ),
                    const SizedBox(height: kSpaceSM),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          onSubmitted: _handleSend,
                          style: GoogleFonts.poppins(
                            fontSize: kFontSM,
                            color: kPrimaryGreen,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Ask BudiBuddy AI anything...',
                            hintStyle: GoogleFonts.poppins(
                              fontSize: kFontSM,
                              color: kTextMuted,
                            ),
                            filled: true,
                            fillColor: kSurfaceGreen,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: kSpaceMD,
                              vertical: kSpaceSM,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(kRadiusXL),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: kSpaceSM),
                      GestureDetector(
                        onTap: () => _handleSend(),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: kPrimaryGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.send_rounded,
                            color: kWhite,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: GoogleFonts.poppins(
        fontSize: kFontXS,
        fontWeight: FontWeight.w600,
        color: kTextMuted,
        letterSpacing: 0.08,
      ),
    );
  }
}

class _InsightSkeleton extends StatelessWidget {
  const _InsightSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(kRadiusLG),
        border: Border.all(color: kSurfaceGreen),
      ),
      padding: const EdgeInsets.all(kSpaceMD),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: kSurfaceGreen,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: kSpaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 10,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: kSurfaceGreen,
                    borderRadius: BorderRadius.circular(kRadiusSM),
                  ),
                ),
                const SizedBox(height: kSpaceSM),
                Container(
                  height: 10,
                  width: 140,
                  decoration: BoxDecoration(
                    color: kSurfaceGreen,
                    borderRadius: BorderRadius.circular(kRadiusSM),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: kPrimaryGreen,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Icon(
                Icons.smart_toy_outlined,
                color: kPrimaryAmber,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: kSpaceMD,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              border: Border.all(color: kSurfaceGreen, width: 1.0),
            ),
            child: SizedBox(
              width: 28,
              height: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  3,
                  (index) => Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: kTextMuted,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
