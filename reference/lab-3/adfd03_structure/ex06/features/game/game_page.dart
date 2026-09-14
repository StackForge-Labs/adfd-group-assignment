import 'package:flutter/material.dart';

import 'game_model.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    const GameModel model = GameModel(name: 'Game');

    return Scaffold(
      appBar: AppBar(title: Text(model.name), centerTitle: true),
      body: Center(
        child: Text(
          model.name,
          style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
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
			└── game_model.dart
*/
