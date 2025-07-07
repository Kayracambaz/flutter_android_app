import 'package:flutter/material.dart';

class TextInputWidget extends StatefulWidget {
  final Function(String) onSubmitted;

  const TextInputWidget(this.onSubmitted, {super.key});

  @override
  State<TextInputWidget> createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    widget.onSubmitted(text);
    FocusScope.of(context).unfocus();
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.message),
          labelText: "Type a message...",
          suffixIcon: IconButton(
            icon: const Icon(Icons.send),
            splashColor: Colors.blue,
            tooltip: "Send message",
            onPressed: _handleSend,
          ),
          border: const OutlineInputBorder(),
        ),
        onSubmitted: (_) => _handleSend(),
      ),
    );
  }
}
