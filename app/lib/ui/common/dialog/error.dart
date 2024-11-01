import "package:flutter/material.dart";

final class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    super.key,
    required this.message,
    this.width = 512,
    this.height = 256,
  });

  final String message;
  final double width;
  final double height;

  @override
  Widget build(context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(
            Icons.error,
            color: Colors.pink,
          ),
          SizedBox(
            width: 16,
          ),
          Text(
            "Error",
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: width,
        height: height,
        child: Text(message),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Close"),
        ),
      ],
    );
  }
}
