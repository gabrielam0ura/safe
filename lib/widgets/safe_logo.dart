import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SafeLogo extends StatelessWidget {
  const SafeLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/Safe.svg',
      width: 78,
      height: 58,
    );
  }
}
