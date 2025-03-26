import 'package:flutter/material.dart';

class TextButtonComponent extends StatefulWidget {
  final VoidCallback onPressed;
  final String buttonText;

  const TextButtonComponent(
      {super.key, required this.onPressed, required this.buttonText});

  @override
  _TextButtonComponentState createState() => _TextButtonComponentState();
}

class _TextButtonComponentState extends State<TextButtonComponent> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.blue,
            minimumSize: const Size(200, 50),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: () {
            widget.onPressed();
          },
          child: Text(widget.buttonText),
        );
  }
}
