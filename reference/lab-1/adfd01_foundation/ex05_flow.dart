import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('ADFD 5/7: Foundation')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            /* Flow 5 - Button & Event Handling */
            children: [
              const CustomText(text: '🍃 Welcome to ADFD 🍃'),
              const Text('Application Development using Flutter & Dart'),
              ElevatedButton(
                onPressed: () {
                  debugPrint('Button clicked');
                },
                child: const Text('Click Me'),
              ),
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
	ElevatedButton
		|
		|_ child
		|    |
		|    V
		|  Text('Click Me')
		|
		|_ onPressed
				|
				V
			callback
				|
				V
			debugPrint()

*/
