import 'package:flutter/material.dart';

class TextInputWidget extends StatefulWidget {
  final Function(String) callback;

  const TextInputWidget(this.callback, {super.key});

  @override
  State<TextInputWidget> createState() => _TextInputWidgetState();
}

class _TextInputWidgetState extends State<TextInputWidget> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void click() {
    widget.callback(controller.text);
    FocusScope.of(context).unfocus();
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.message),
        labelText: "Type a message:",
        suffixIcon: IconButton(
          icon: const Icon(Icons.send),
          splashColor: Colors.blue,
          tooltip: "Post message",
          onPressed: click,
        ),
      ),
    );
  }
}
