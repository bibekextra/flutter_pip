import 'package:flutter/material.dart';

class PipScreenWidget extends StatefulWidget {
  PipScreenWidget({
    Key key,
    @required this.child,
    @required this.numerator,
    @required this.denominator,
    this.pipOnVisibility = true,
  }) : super(key: key);

  final double numerator;
  final double denominator;
  final bool pipOnVisibility;
  final Widget child;

  @override
  PipScreenWidgetState createState() => PipScreenWidgetState();
}

class PipScreenWidgetState extends State<PipScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
