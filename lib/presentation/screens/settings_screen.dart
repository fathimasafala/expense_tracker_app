// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/theme_cubit/theme_cubit.dart';
import '../widgets/widgets.dart';
import 'about_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Settings',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SettingsCard(
                  onTap: () => Navigator.pop(context, 'es'),
                  icon: Icons.language,
                  title: "change language"),
              SettingsCard(
                onTap: () {
                  context.read<ThemeCubit>().toggleTheme();
                },
                icon: Icons.color_lens_rounded,
                title: 'Change Theme',
              ),
              SettingsCard(
                onTap: () async {
                  const url = 'http://localhost:8080/privacy-policy';
                  if (await canLaunch(url)) {
                    await launch(
                      url,
                      forceSafariVC: false,
                      forceWebView: false,
                    );
                  } else {
                  }
                },
                icon: Icons.local_parking_outlined,
                title: 'Privacy Policy',
              ),
              SettingsCard(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AboutScreen(),
                    ),
                  );
                },
                icon: Icons.info_rounded,
                title: 'About App',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
