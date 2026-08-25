import 'package:flutter/material.dart';

import '../app_language.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isPt = appSettings.language == AppLanguage.portuguese;
    return Center(
      child: Text(isPt ? 'Página Perfil' : 'Profile Page', style: const TextStyle(fontSize: 24)),
    );
  }
}
