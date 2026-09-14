import 'package:flutter/material.dart';

import 'game_model.dart';
import '../../shared/shared_widget.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    const GameModel model = GameModel(name: 'Game');

    return Scaffold(
      appBar: AppBar(title: Text(model.name), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SharedWidget(),

            Text(
              model.name,
              style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

/*
	features/
		└── game/
			├── game_page.dart
			│        ↑
			│        │ model
			│        │
			│        └── SharedWidget
			│
			└── game_model.dart

	Ex08:
		GamePage
			↓
		SharedWidget
*/
