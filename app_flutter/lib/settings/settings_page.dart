import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../app_language.dart';
import '../l10n.dart';
import 'terms_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() => appVersion = info.version);
  }

  Widget _infoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appSettings,
      builder: (context, _) {
        final l10n = L10n(appSettings.language);

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(l10n.settings, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset('assets/images/Armiac_LOGO.png', width: 48, height: 48, fit: BoxFit.contain),
                ),
                title: Text(l10n.appName, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(l10n.appSubtitle),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.languageLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    SegmentedButton<AppLanguage>(
                      segments: [
                        ButtonSegment(
                          value: AppLanguage.portuguese,
                          label: Text(l10n.portuguese),
                          icon: const Text('🇵🇹'),
                        ),
                        ButtonSegment(
                          value: AppLanguage.english,
                          label: Text(l10n.english),
                          icon: const Text('🇬🇧'),
                        ),
                      ],
                      selected: {appSettings.language},
                      onSelectionChanged: (selection) {
                        appSettings.setLanguage(selection.first);
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(l10n.languageHelp, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
            _infoTile(
              icon: Icons.mic,
              title: l10n.microphonePermission,
              subtitle: l10n.microphonePermissionBody,
            ),
            _infoTile(
              icon: Icons.wifi,
              title: l10n.armiacConnection,
              subtitle: l10n.armiacConnectionBody,
            ),
            const SizedBox(height: 12),
            Text(
              '${l10n.appVersion}: $appVersion',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Center(
              child: TextButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TermsPage()),
                ),
                icon: const Icon(Icons.open_in_new),
                label: Text(l10n.serviceTerms),
              ),
            ),
          ],
        );
      },
    );
  }
}
