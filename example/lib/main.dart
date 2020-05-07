import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pip/flutter_pip.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AfterLayoutMixin {
  @override
  void afterFirstLayout(BuildContext context) {
    final size = MediaQuery.of(context).size;
    FlutterPip.setPipReady(size.width + (size.width * 0.6), size.height);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    print('Width: ${size.width}');
    print('Height: ${size.height}');
    return PipAwareWidget(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text('Flutter PiP Example'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.picture_in_picture_alt),
              onPressed: () {
                FlutterPip.switchToPiPMode();
              },
            )
          ],
        ),
        body: Center(
          child: Text(
              'Press Home button or Action Button to Proceed to PiP Mode.'),
        ),
      ),
      pipBuilder: (context) => Scaffold(
        body: Center(
          child: Text('Pip Mode'),
        ),
      ),
    );
  }
}
