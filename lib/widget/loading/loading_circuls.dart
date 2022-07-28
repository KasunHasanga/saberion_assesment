import 'package:flutter/material.dart';

class Loadingcircul extends StatelessWidget {
  final Color color;
  Loadingcircul({required this.color});
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(color),
    );
  }
}