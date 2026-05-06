import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'terms_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String appVersion = "";

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() => appVersion = "${info.version} (${info.buildNumber})");
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Configurações", style: TextStyle(fontSize: 24)),
          const SizedBox(height: 20),
          Text("Versão do app: $appVersion",
              style: const TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 30),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TermsPage()),
            ),
            child: const Text(
              "Termos de serviço🔗",
              style: TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
