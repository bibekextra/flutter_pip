import 'package:flutter/material.dart';

import 'flutter_pip.dart';

class PipAwareWidget extends StatefulWidget {
  PipAwareWidget({
    Key key,
    @required this.builder,
    @required this.pipBuilder,
  }) : super(key: key);

  final WidgetBuilder builder;
  final WidgetBuilder pipBuilder;

  @override
  PipAwareWidgetState createState() => PipAwareWidgetState();
}

class PipAwareWidgetState extends State<PipAwareWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: FlutterPip.onPiPModeChanged,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data) {
          return widget.pipBuilder(context);
        }
        return widget.builder(context);
      },
    );
  }
}
