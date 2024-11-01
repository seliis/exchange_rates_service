import "package:flutter/material.dart";

final class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    super.key,
    required this.message,
  });

  final String message;

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
        width: 512,
        height: 256,
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
