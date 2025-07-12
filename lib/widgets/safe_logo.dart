import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SafeLogo extends StatelessWidget {
  final String asset;
  const SafeLogo({super.key, this.asset = 'assets/safe-dark.svg'});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      width: 78,
      height: 58,
    );
  }
}
