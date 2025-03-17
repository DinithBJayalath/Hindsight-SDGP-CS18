import 'package:flutter/material.dart';

class LogoTile extends StatelessWidget {
  final String imagePath;
  const LogoTile({
    super.key,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Image.asset(imagePath),
    );
  }
}
