import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('ADFD 3/7: Foundation')),
        body: Center(
          child: CustomText(
            text: "🚀 - Passing Argument in Flutter - 🚀",
          ), //* Flow 3 *
        ),
      ),
    );
  }
}

/* Flow 3 - Pass Arguments to Custom Widget (Dynamic) */
class CustomText extends StatelessWidget {
  final String text;
  const CustomText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }
}

/*
	
	1. Cách viết cũ (tường minh bản chất hướng đối tượng):
   		const CustomText({Key? key, required this.text}) : super(key: key);
	
	2. Cách viết mới {super.key} (từ phiên bản Dart 2.17 trở đi)
		const CustomText({super.key, required this.text});

	Widget
	 |_ Constructor → nhận dữ liệu đầu vào
	 |_ final fields → lưu dữ liệu
	 |_ build() -> tạo UI
*/
