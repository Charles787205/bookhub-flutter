import 'package:bookhub/objects/user.dart';
import 'package:bookhub/components/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LayoutPage extends StatefulWidget {
  final Widget child;
  Widget? title;
  LayoutPage({super.key, required this.child, this.title});

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          centerTitle: true,
          title: widget.title,
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {},
              style: IconButton.styleFrom(
                  backgroundColor: Colors.white70, elevation: 10),
            )
          ],
        ),
        body: widget.child);
  }
}
