import 'package:flutter/material.dart';
import 'package:finance/core/widget/k_app_bar.dart';
import 'package:finance/core/widget/k_padding.dart';
import 'package:finance/core/widget/k_page.dart';
import 'package:finance/core/router/no_animation_page_route.dart';
import 'chat_details.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return KPage(
      child: Scaffold(
        appBar: KAppBar(title: const Text('Your Finance Buddy - Spendy')),
        body: Padding(
          padding: KPadding.defaultPagePadding,
          child: ListView(
            children: [
              _buildChatButton(
                context,
                'Ask Me Anything',
                'Quick answers to your money questions',
                '💬',
              ),
              const SizedBox(height: 12),
              _buildChatButton(
                context,
                'Thinking of Buying Something?',
                'Smart tips before you spend',
                '🛒',
              ),
              const SizedBox(height: 12),
              _buildChatButton(
                context,
                'Where Did My Money Go?',
                'See how your money was spent',
                '📊',
              ),
              const SizedBox(height: 12),
              _buildChatButton(
                context,
                'Saving Helper',
                'Easy ways to save more',
                '💡',
              ),
              const SizedBox(height: 12),
              _buildChatButton(
                context,
                'My Money Plan',
                'Track your budget and goals',
                '🧭',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatButton(
    BuildContext context,
    String title,
    String description,
    String emoji,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          // Navigate to chat details when the entire card is tapped
          _navigateToChatDetails(context, title, description);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  // Navigate to chat details when only the arrow is tapped
                  _navigateToChatDetails(context, title, description);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToChatDetails(
    BuildContext context, [
    String title = 'Chat Details',
    String description = '',
  ]) {
    // We're passing the description as the title for the chat context
    // The actual title "Spendy - Your Finance Buddy" is shown in the AppBar
    final chatTitle = description.isNotEmpty ? description : title;
    Navigator.of(context).pushNoAnimation(ChatDetailsPage(title: chatTitle));
  }
}
