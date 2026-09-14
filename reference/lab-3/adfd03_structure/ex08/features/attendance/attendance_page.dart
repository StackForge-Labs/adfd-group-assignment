import 'package:flutter/material.dart';

import 'attendance_model.dart';
import '../../shared/shared_widget.dart';

class AttendancePage extends StatelessWidget {
  const AttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    const AttendanceModel model = AttendanceModel(name: 'Attendance');

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
		└── attendance/
			├── attendance_page.dart
			│        ↑
			│        │ model
			│        │
			│        └── SharedWidget
			│
			└── attendance_model.dart

	Ex08:
		AttendancePage
			↓
		SharedWidget
*/
