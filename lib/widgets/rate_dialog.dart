import 'package:flutter/material.dart';
import 'package:bookhub/scripts/database.dart';

class RateDialog extends StatefulWidget {
  const RateDialog({super.key});

  @override
  State<RateDialog> createState() => _RateDialogState();
}

class _RateDialogState extends State<RateDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text("Rate Book"),
        content: SizedBox(
          height: 100,
          child: Column(
            children: [
              const Text('How many stars would you rate this book?'),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.star),
                    onPressed: () => Navigator.pop(context, 1),
                  ),
                  IconButton(
                    icon: const Icon(Icons.star),
                    onPressed: () => Navigator.pop(context, 2),
                  ),
                  IconButton(
                    icon: const Icon(Icons.star),
                    onPressed: () => Navigator.pop(context, 3),
                  ),
                  IconButton(
                    icon: const Icon(Icons.star),
                    onPressed: () => Navigator.pop(context, 4),
                  ),
                  IconButton(
                    icon: const Icon(Icons.star),
                    onPressed: () => Navigator.pop(context, 5),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
