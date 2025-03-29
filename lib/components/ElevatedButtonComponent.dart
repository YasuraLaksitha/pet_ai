import 'package:flutter/material.dart';

class ElevatedButtonComponent extends StatefulWidget {
  final VoidCallback? onPressed;
  final String buttonText;
  final Icon icon;

  const ElevatedButtonComponent(
      {super.key,
      required this.onPressed,
      required this.buttonText,
      required this.icon});

  @override
  State<StatefulWidget> createState() => _ElevatedButtonComponentState();
}

class _ElevatedButtonComponentState extends State<ElevatedButtonComponent> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: widget.icon,
      onPressed: widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        minimumSize: Size(250.51, 55.1),
      ),
      label: Text(widget.buttonText,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal)
      ),
    );
  }
}
