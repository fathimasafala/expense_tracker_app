
import 'package:expense_test_app/utils/resources/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormFields extends StatelessWidget {
  final String? title;
  final bool? titleis;
  final String? subtitle;
  final bool? subtitleis;
  final Widget? suffixIcon;
  final int? maxLines;
  final bool? isRequired;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final double? width;
  final void Function()? onEditingComplete;
  final TextEditingController? controller;
  final bool? readOnly;
  final bool? enabled;
  final void Function()? onTap;
  final TextInputType? keyboardType;
  final Color? cursorColor;
  final String? initialValue;

  const CustomTextFormFields({
    super.key,
    this.suffixIcon,
    this.title,
    this.controller,
    this.subtitle,
    this.subtitleis = false,
    this.maxLines,
    this.hintText,
    this.isRequired = false,
    this.prefixIcon,
    this.readOnly = false,
    this.onTap,
    this.titleis = true,
    this.keyboardType,
    this.cursorColor,
    this.inputFormatters,
    this.width,
    this.enabled,
    this.onEditingComplete,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              titleis == true
                  ? Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 0, bottom: 5, top: 8),
                          child: Text( title.toString(), style: const TextStyle(fontSize: 14,color: Colors.white)),
                        ),
                        isRequired == true ? const Text('*', style: TextStyle(color: Colors.red)) : const SizedBox.shrink(),
                      ],
                    )
                  : const SizedBox.shrink(),
              subtitleis == true
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 5, top: 7, right: 5),
                      child: Text(subtitle.toString(), style: const TextStyle(fontSize: 14)),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          SizedBox(
            height: 55,
            child: TextFormField(
              readOnly: readOnly ?? false,
              controller: controller,
              initialValue: initialValue,
              cursorColor: Colors.white,
              onTap: onTap,
              inputFormatters: inputFormatters,
              keyboardType: keyboardType,
              maxLines: maxLines ?? 1,
              cursorHeight: 20,
              decoration: InputDecoration(
                hintStyle: const TextStyle(fontSize: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: StyleResources.primarycolor,width: 1)),
                fillColor:Colors.black,
                filled: true,
                contentPadding: const EdgeInsets.all(10),
                enabled: enabled ?? true,
                suffixIcon: suffixIcon,
              
                hintText: hintText,
                prefixIcon: prefixIcon,
              ),
              style: const TextStyle(color: Colors.white),
              onEditingComplete: onEditingComplete,
            ),
          ),
        ],
      ),
    );
  }
}
