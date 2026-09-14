import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('ADFD 4/7: Foundation')),
        body: Center(
          //* Flow 4 - Column & children *
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CustomText(text: '🍃 Welcome to ADFD 🍃'),
              const Text('Application Development using Flutter & Dart'),
            ],
          ),
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
	child: Text(...)	-> nhận một Widget.
	--------------------------------------------
	children: [
		Text(...),
		Text(...),
	] 					-> nhận nhiều Widget

*/
