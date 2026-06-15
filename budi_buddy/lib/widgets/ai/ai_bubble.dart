import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../core/constants.dart';
import '../../providers/ai_provider.dart';

class AIBubble extends StatelessWidget {
  const AIBubble({super.key, required this.message});

  final AIMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
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
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  decoration: BoxDecoration(
                    color: isUser ? kPrimaryGreen : kWhite,
                    borderRadius: isUser
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(4),
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          )
                        : const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                    border: isUser
                        ? null
                        : Border.all(color: kSurfaceGreen, width: 1.0),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    message.content,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      height: 1.6,
                      color: isUser ? kWhite : kPrimaryGreen,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('h:mm a').format(message.timestamp),
                  style: GoogleFonts.poppins(fontSize: 10, color: kTextMuted),
                ),
              ],
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: kSurfaceGreen,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(
                  Icons.person_outlined,
                  color: kPrimaryGreen,
                  size: 18,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
