import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('ADFD 7/7: Foundation')),
        body: Center(
          child: CounterPage(), //* Flow 6 *
        ),
      ),
    );
  }
}

//* Flow 6 - StatefulWidget & State *
class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => CounterPageState();
}

class CounterPageState extends State<CounterPage> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Counter: $counter'),
        ElevatedButton(
          onPressed: () {
            // debugPrint('Button clicked');
            /* Flow 7 - setState() */
            setState(() {
              counter++;
            });
          },
          child: Text('Increase'),
        ),
      ],
    );
  }
}

/*
	Flow 5 - Button & Event Handling
		CustomText
			|
			V
		StatelessWidget

	Flow 6 - StatefulWidget & State
		CounterPage
			|
			V
		StatefulWidget
			|
			V
		CounterPageState
			|
			V
		  State
*/
