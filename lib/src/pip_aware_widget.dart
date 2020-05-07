import 'package:flutter/material.dart';

import 'flutter_pip.dart';

class PipAwareWidget extends StatelessWidget {
  PipAwareWidget({
    Key key,
    @required this.builder,
    @required this.pipBuilder,
  }) : super(key: key);

  final WidgetBuilder builder;
  final WidgetBuilder pipBuilder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: FlutterPip.onPiPModeChanged,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data) {
          return pipBuilder(context);
        }
        return builder(context);
      },
    );
  }
}
