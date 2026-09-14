import 'package:flutter/material.dart';

import 'payroll_model.dart';
import '../../shared/shared_widget.dart';

class PayrollPage extends StatelessWidget {
  const PayrollPage({super.key});

  @override
  Widget build(BuildContext context) {
    const PayrollModel model = PayrollModel(name: 'Payroll');

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
		└── payroll/
			├── payroll_page.dart
			│        ↑
			│        │ model
			│        │
			│        └── SharedWidget
			│
			└── payroll_model.dart

	Ex08:
		PayrollPage
			↓
		SharedWidget
*/
