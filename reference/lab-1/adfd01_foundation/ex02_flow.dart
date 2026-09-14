import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('ADFD 2/7: Foundation')),
        body: Center(
          //   child: Text('Hello Flutter'), //* Flow 1 *
          child: CustomText(), //* Flow 2 *
        ),
      ),
    );
  }
}

/* Flow 2 - Create a Custom Widget (Static) */
class CustomText extends StatelessWidget {
  const CustomText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('💥 - Hello Flutter - \u{1F4A5}');
  }
}

/*
	Press Win + ; (or .)
	💥: entity code (hexa) \u{1F4A5}
	
		CustomText
		  |
		  V
		build()
		  |
		  V
		Text
*/
