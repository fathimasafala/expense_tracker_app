import 'package:flutter/material.dart';
import '../utils/resources/color_resources.dart';

class BottomCustomButton extends StatelessWidget {
  final String text;
  final double? width;
  final void Function()? onTap;
  const BottomCustomButton({super.key, required this.text, required this.onTap, this.width});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? MediaQuery.sizeOf(context).width * 1,
        height: 55,
        decoration: BoxDecoration(
          color: StyleResources.primarycolor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child:Text(
           text.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
