import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finance/core/router/no_animation_page_route.dart';
import 'dart:math';

/// Simple mock chat provider to generate responses
class MockChatProvider {
  final Random _random = Random();
  final List<Map<String, String>> _conversationHistory = [];

  // Path to the logo asset
  final String logo = 'assets/images/logo.png';

  /// Generates a mock response based on the user's message
  Future<String> sendMessage(String message) async {
    // Add user message to conversation history
    _conversationHistory.add({'role': 'user', 'content': message});

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Convert message to lowercase for easier matching
    final input = message.toLowerCase();

    String response;

    // Basic hardcoded response logic
    if (input.contains('hello') || input.contains('hi')) {
      response = 'Hi there! How can I assist you with your finances today?';
    } else if (input.contains('budget')) {
      response =
          'To manage your budget, I recommend tracking your daily expenses and setting a monthly limit.';
    } else if (input.contains('save')) {
      response =
          'Saving tip: Try the 50/30/20 rule! Spend 50% on needs, 30% on wants, and save 20%.';
    } else if (input.contains('spent') || input.contains('spending')) {
      response =
          'You can view your spending summary by navigating to the “Spending Overview” section.';
    } else if (input.contains('investment') || input.contains('invest')) {
      response =
          'Investing regularly in diversified funds is a great strategy! I can guide you through options.';
    } else if (input.contains('help') || input.contains('advice')) {
      response =
          'Sure! Just let me know what area of finance you need help with—budgeting, saving, or investing.';
    } else if (input.contains('tip') || input.contains('tips')) {
      response =
          'Here’s a tip: Automate your savings to stay consistent and avoid unnecessary spending.';
    } else if (input.contains('bye') || input.contains('goodbye')) {
      response = 'Goodbye! Come back anytime if you need more financial help!';
    } else {
      // Default fallback response
      response =
          'I’m here to help with anything related to saving, budgeting, or spending. Could you be more specific?';
    }

    // Add assistant response to conversation history
    _conversationHistory.add({'role': 'assistant', 'content': response});

    return response;
  }

  void clearConversation() {
    _conversationHistory.clear();
  }
}

class ChatDetailsPage extends StatefulWidget {
  final String title;

  const ChatDetailsPage({super.key, required this.title});

  @override
  State<ChatDetailsPage> createState() => _ChatDetailsPageState();
}

class _ChatDetailsPageState extends State<ChatDetailsPage>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final MockChatProvider _chatProvider = MockChatProvider();

  // Local messages list for UI display
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: 'Hello! I\'m your finance buddy, Spendy. How can I help you today?',
      isMe: false,
      time: DateTime.now().subtract(const Duration(seconds: 5)),
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final userMessage = _messageController.text.trim();
    if (userMessage.isEmpty) return;

    // Add user message to UI
    setState(() {
      _messages.add(
        ChatMessage(text: userMessage, isMe: true, time: DateTime.now()),
      );
      _messageController.clear();
    });

    // Scroll to the bottom after sending a message
    _scrollToBottom();

    // Add a "typing" indicator
    setState(() {
      _messages.add(
        ChatMessage(
          text: '...',
          isMe: false,
          time: DateTime.now(),
          isTyping: true,
        ),
      );
    });

    // Scroll to show the typing indicator
    _scrollToBottom();

    try {
      // Send message and get response
      final response = await _chatProvider.sendMessage(userMessage);

      // Remove typing indicator and add the actual response
      setState(() {
        // Remove the typing indicator
        _messages.removeLast();

        // Add the AI response
        _messages.add(
          ChatMessage(text: response, isMe: false, time: DateTime.now()),
        );
      });

      // Scroll to the bottom to show the response
      _scrollToBottom();
    } catch (e) {
      // Handle error - remove typing indicator and show error message
      setState(() {
        // Remove the typing indicator
        _messages.removeLast();

        // Add error message
        _messages.add(
          ChatMessage(
            text: 'Sorry, I encountered an error: ${e.toString()}',
            isMe: false,
            time: DateTime.now(),
            isError: true,
          ),
        );
      });

      _scrollToBottom();
    }
  }

  /// Scrolls to the bottom of the chat
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  /// Returns the appropriate title based on the chat context
  String _getShortDescription(String title) {
    switch (title) {
      case 'Quick answers to your money questions':
        return 'General Help';
      case 'Smart tips before you spend':
        return 'Purchase Advice';
      case 'See how your money was spent':
        return 'Spending Overview';
      case 'Easy ways to save more':
        return 'Savings Tips';
      case 'Track your budget and goals':
        return 'Budget Planner';
      default:
        return title; // If it's already a short description, just return it
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).popNoAnimation();
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(_chatProvider.logo),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _getShortDescription(widget.title),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Chat messages area
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: Colors.white),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(10),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildMessageBubble(message);
                },
              ),
            ),
          ),

          // Message input area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: (_) => _sendMessage(),
                    enableInteractiveSelection:
                        false, // Disables text selection toolbar
                    toolbarOptions: ToolbarOptions(
                      copy: false,
                      cut: false,
                      paste: false,
                      selectAll: false,
                    ), // Disables copy/paste toolbar
                    showCursor: true,
                    autocorrect: false, // Disables autocorrect suggestions
                    enableSuggestions: false, // Disables word suggestions
                  ),
                ),
                TextButton(
                  onPressed: _sendMessage,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  child: const Text(
                    'Send',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final time = DateFormat('HH:mm').format(message.time);

    // For typing indicator
    if (message.isTyping) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 40,
                child: Row(
                  children: [_buildDot(0), _buildDot(1), _buildDot(2)],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color:
              message.isError
                  ? Colors.red[50]
                  : (message.isMe ? const Color(0xFFE1D9F0) : Colors.white),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.text,
              style: TextStyle(
                fontSize: 16,
                color: message.isError ? Colors.red[700] : null,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
                if (message.isMe) ...[
                  const SizedBox(width: 3),
                  Icon(
                    Icons.done_all,
                    size: 14,
                    color: message.isRead ? Colors.blue : Colors.grey[400],
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a typing indicator dot
  Widget _buildDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      height: 8,
      width: 8,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        shape: BoxShape.circle,
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime time;
  final bool isRead;
  final bool isTyping;
  final bool isError;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
    this.isRead = true,
    this.isTyping = false,
    this.isError = false,
  });
}
