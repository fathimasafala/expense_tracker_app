
import 'package:expense_test_app/widgets/rounded_image.dart';
import 'package:expense_test_app/utils/resources/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String appName = "App Name";
  String packageName = "Package Name";
  String version = "Version";

  PackageInfo? packageInfo;

  @override
  void initState() {
    loadInfo();
    super.initState();
  }

  Future<void> loadInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appName = packageInfo!.appName;
      packageName = packageInfo!.packageName;
      version = packageInfo!.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
           iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('About App',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 25),),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(width: double.infinity),
            const RoundedImage(asset: 'assets/images/app_icon.jpeg',),
            Text(
              appName,
              style: const TextStyle(
                  fontSize: 32,color: StyleResources.primarycolor),
            ),
            const SizedBox(height: 32.0),
            Text(
              packageName,
              style: const TextStyle(fontSize: 20,color: Colors.grey),
            ),
            const SizedBox(height: 32.0),
            Text(
              'Version: $version',
              style: const TextStyle(fontSize: 18,color: Colors.grey),
            ),
            const SizedBox(height: 32.0),
          ],
        ),
      ),
    );
  }
}
