import 'package:flutter/material.dart';

import '../models/start_card_model.dart';

class StartCard extends StatelessWidget {
  final StartCardModel model;
  final VoidCallback? onTap;

  const StartCard({super.key, required this.model, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(model.icon, size: 40),
              const SizedBox(height: 9),
              Text(
                model.title,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
	StartCard
		├── model → StartCardModel
		│       ├── title
		│       └── icon
		│
		└── onTap → callback từ Page

	Ex05 → StartCard
			↓
	Ex06 → StartCard
			├── model
			└── onTap
				↓
			HomePage xử lý navigation

	Khái niệm chính:
		- Widget nhận dữ liệu qua model
		- Widget nhận callback qua onTap
		- Widget không chứa business logic
*/
