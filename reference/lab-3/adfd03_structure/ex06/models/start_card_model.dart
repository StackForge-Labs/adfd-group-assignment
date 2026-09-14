import 'package:flutter/material.dart';

class StartCardModel {
  final String title;
  final IconData icon;

  const StartCardModel({required this.title, required this.icon});
}

/*
StartCardModel
    ├── title → dữ liệu
    └── icon  → dữ liệu

Ex05 → StartCardModel
        ↓
Ex06 → StartCardModel
        └── code như Ex05
*/
/*
	StartCardModel
		├── title → dữ liệu
		└── icon  → dữ liệu
		
	Ex05 → StartCardModel
        ↓
	Ex06 → StartCardModel
			└── code như Ex05
*/
