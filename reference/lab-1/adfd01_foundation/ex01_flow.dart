import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('ADFD 1/7: Foundation')),
        body: Center(
          child: Text('Hello Flutter'), //* Flow 1 *
        ),
      ),
    );
  }
}

/*
		Flutter      vs   	React
	------------------------------------------------
	Widget				Component
	StatelessWidget     Component không state
	StatefulWidget      Component có state
	MyApp               <App />
	MaterialApp         App-level configuration
	Scaffold            Page/Layout component
	build()             render()
	setState()          setState()
	Navigator           React Router

	  	main()
		 |
		 V
		runApp()
		 |
		V
		MyApp           <- <App /> trong React
		 |
		 V
		MaterialApp     <- App-level configuration
		 |
		 V
		Scaffold        <- Page/Layout
		 |_ AppBar
		 |    |_ Text
		 |
		 |_ body
			 |_ Center
				  |_ Text
*/
