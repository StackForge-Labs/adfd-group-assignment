import 'package:flutter/material.dart';

import '../models/start_card_model.dart';

class StartCard extends StatelessWidget {
  final StartCardModel model; //Thay title, icon

  const StartCard({
    super.key,
    required this.model, // //Thay title, icon
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(model.icon, size: 40),
            const SizedBox(height: 9),
            Text(
              model.title,
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
