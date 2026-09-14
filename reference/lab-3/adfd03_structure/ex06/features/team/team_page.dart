import 'package:flutter/material.dart';

import 'team_model.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    const TeamModel model = TeamModel(name: 'Team');

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
		└── team/
			├── team_page.dart
			│        ↑
			│        │ model
			│        │
			└── team_model.dart
*/
