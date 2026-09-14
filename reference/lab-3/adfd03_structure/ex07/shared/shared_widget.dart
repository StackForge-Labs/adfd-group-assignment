import 'package:flutter/material.dart';

class SharedWidget extends StatelessWidget {
  const SharedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Shared Widget',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}

/*
	Ex07 → Shared
		└── Giới thiệu SharedWidget

	Shared cái gì?
		└── UI component "Shared Widget"
			└── hiển thị Text: "Shared Widget"

	Phạm vi Ex07:
		HomePage
			↓
		SharedWidget

	Các Feature Page sử dụng SharedWidget
	→ hẹn lại Version sau (Ex08):
		├── AttendancePage
		├── PayrollPage
		├── TeamPage
		└── GamePage
*/
