
import 'package:expense_test_app/utils/resources/color_resources.dart';
import 'package:flutter/material.dart';

class SettingsCard extends StatelessWidget {
  final void Function()? onTap;
  final IconData icon;
  final String title;

  const SettingsCard({
    super.key,
    required this.onTap,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(width: 1,color: StyleResources.primarycolor)
      ),
      color: Colors.black,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 30.0,
                color:StyleResources.primarycolor,
              ),
              const SizedBox(width: 16.0),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
