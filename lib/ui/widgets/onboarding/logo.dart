import 'package:chat_app/theme.dart';
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset('assets/logo.png',
          fit: BoxFit.cover, width: 80, height: 80),
    );
  }
}
