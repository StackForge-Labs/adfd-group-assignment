import 'package:flutter/material.dart';

class StartCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const StartCard({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 9),
            Text(
              title,
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
