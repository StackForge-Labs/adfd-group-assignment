import 'package:flutter/material.dart';

import 'team_model.dart';
import '../../shared/shared_widget.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    const TeamModel model = TeamModel(name: 'Team');

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
		└── team/
			├── team_page.dart
			│        ↑
			│        │ model
			│        │
			│        └── SharedWidget
			│
			└── team_model.dart

	Ex08:
		TeamPage
			↓
		SharedWidget
*/
