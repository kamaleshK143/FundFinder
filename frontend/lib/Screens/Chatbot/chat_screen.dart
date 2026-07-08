import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fundfinderff/models/scholarship.dart';
import 'package:fundfinderff/widgets/scholarship_card.dart';
import 'chat_provider.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Text(
          "Guided Scholarship Finder",
          style: GoogleFonts.poppins(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            const Expanded(child: ChatMessages()),
            const ChatInputField(),
          ],
        ),
      ),
    );
  }
}

class ChatMessages extends StatefulWidget {
  const ChatMessages({super.key});

  @override
  State<ChatMessages> createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        _scrollToBottom();

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          itemCount: chatProvider.messages.length,
          itemBuilder: (context, index) {
            final message = chatProvider.messages[index];

            if (message["isOption"] == true) {
              return OptionButton(optionText: message["text"]);
            } else if (message["type"] == "scholarship") {
              final Scholarship scholarship = message["scholarship"];
              return ScholarshipCard(scholarship: scholarship);
            } else {
              return ChatBubble(text: message["text"], isUser: message["isUser"]);
            }
          },
        );
      },
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatBubble({super.key, required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isUser ? Colors.deepPurple : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(0),
            bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(2, 2),
            )
          ],
        ),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Text(
          text,
          style: GoogleFonts.poppins(color: isUser ? Colors.white : Colors.black87),
        ),
      ),
    );
  }
}

class OptionButton extends StatelessWidget {
  final String optionText;

  const OptionButton({super.key, required this.optionText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF4F8ED5),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: () {
          Provider.of<ChatProvider>(context, listen: false).sendUserMessage(optionText);
        },
        child: Text(optionText),
      ),
    );
  }
}

class ChatInputField extends StatefulWidget {
  const ChatInputField({super.key});

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    Provider.of<ChatProvider>(context, listen: false).sendUserMessage(_controller.text.trim());
    _controller.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(8),
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Type your answer...",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onChanged: (_) => setState(() {}),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 10),
            FloatingActionButton(
              onPressed: _controller.text.trim().isEmpty ? null : _sendMessage,
              backgroundColor: Color(0xFF4F8ED5),
              child: const Icon(Icons.send, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
