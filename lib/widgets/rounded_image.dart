import 'package:flutter/material.dart';

class RoundedImage extends StatelessWidget {
  final String asset;

  const RoundedImage({
    super.key,
    required this.asset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 140,
      height: MediaQuery.of(context).size.width - 140
      ,
      margin: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular((MediaQuery.of(context).size.width - 40) / 2),
        child: Image.asset(
          asset,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
