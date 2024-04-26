import 'package:flutter/material.dart';

class DashboardButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final IconData icon;
  final int notificationCount;
  const DashboardButton(
      {super.key,
      required this.title,
      required this.onPressed,
      this.notificationCount = 0,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topRight, children: [
      SizedBox.expand(
        child: ElevatedButton(
          onPressed: () {
            onPressed();
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(10),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            //backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            elevation: 4,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.category,
                  size: 40, color: Theme.of(context).colorScheme.tertiary),
              Text(title,
                  style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).colorScheme.tertiary)),
            ],
          ),
        ),
      ),
      if (notificationCount > 0)
        Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          constraints: const BoxConstraints(
            minWidth: 16,
            minHeight: 16,
          ),
          child: Text(
            "$notificationCount",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
    ]);
    ;
  }
}
