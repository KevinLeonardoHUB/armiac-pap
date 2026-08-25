import 'dart:convert';

import 'package:http/http.dart' as http;

import '../app_language.dart';

/// Serviço opcional para usar IA gratuita na interpretação de comandos.
///
/// Para a PAP funcionar sem internet e sem chave, deixe [geminiApiKey] vazio.
/// Quando quiser testar com Gemini, coloque a chave em:
/// --dart-define=GEMINI_API_KEY=SUA_CHAVE
class AiCommandService {
  AiCommandService._();
  static final AiCommandService instance = AiCommandService._();

  static const String geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');

  static const List<String> validCommands = [
    'open_hand',
    'close_hand',
    'peace',
    'point',
    'three',
    'thumbs_up',
    'ok',
    'wave',
    'palm_up',
    'palm_down',
    'forearm_neutral',
    'demo',
    'close_index',
    'open_index',
    'close_middle',
    'open_middle',
    'close_ringpinky',
    'open_ringpinky',
    'close_thumb',
    'open_thumb',
  ];

  bool get isConfigured => geminiApiKey.trim().isNotEmpty;

  Future<String?> understandWithGemini(String spokenText, AppLanguage language) async {
    if (!isConfigured) return null;

    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$geminiApiKey',
    );

    final languageName = language == AppLanguage.portuguese ? 'Portuguese' : 'English';
    final examples = language == AppLanguage.portuguese
        ? '''
- abrir mão / abre a mão / resetar => open_hand
- fechar mão / punho => close_hand
- paz / vitória / número dois => peace
- apontar / número um => point
- número três / três dedos => three
- joinha / positivo => thumbs_up
- acenar / olá / adeus => wave
- palma para cima / supinação => palm_up
- palma para baixo / pronação => palm_down
- antebraço ao centro / posição neutra => forearm_neutral
- demonstração => demo
'''
        : '''
- open hand / reset / open all => open_hand
- close hand / fist / make a fist => close_hand
- peace / victory / number two => peace
- point / number one => point
- number three / three fingers => three
- thumbs up / like => thumbs_up
- wave / hello / bye => wave
- palm up / face up / supination => palm_up
- palm down / face down / pronation => palm_down
- neutral forearm / center forearm => forearm_neutral
- demo / demonstration => demo
''';

    final prompt = '''
You control a robotic hand called ARMIAC.
The app is currently set to $languageName.
Only understand commands in $languageName. If the user speaks another language, return UNKNOWN.
Return ONLY one command from this exact list:
${validCommands.join(', ')}

Examples:
$examples
If the phrase is unclear, return UNKNOWN.

User speech: "$spokenText"
''';

    try {
      final response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'contents': [
                {
                  'parts': [
                    {'text': prompt}
                  ]
                }
              ],
              'generationConfig': {
                'temperature': 0,
                'maxOutputTokens': 10,
              }
            }),
          )
          .timeout(const Duration(seconds: 6));

      if (response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final text = data['candidates']?[0]?['content']?['parts']?[0]?['text']
          ?.toString()
          .trim()
          .toLowerCase();

      if (text == null || text == 'unknown') return null;
      return validCommands.contains(text) ? text : null;
    } catch (_) {
      return null;
    }
  }
}
