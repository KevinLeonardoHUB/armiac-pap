import 'dart:math';

class LocalCommandAiService {
  static const Map<String, List<String>> strongPhrases = {
    'open_hand': [
      'abrir mao',
      'abre mao',
      'abre a mao',
      'abrir a mao',
      'abrir os dedos',
      'abre os dedos',
      'abrir todos os dedos',
      'abre todos os dedos',
      'deixa a mao aberta',
      'solta a mao',
      'liberta a mao',
      'abre completamente',
      'abre totalmente a mao',
      'estende a mao',
      'deixa os dedos abertos',
      'estica os dedos',
      'mao aberta',
      'open hand',
      'open the hand',
      'open fingers',
      'open all fingers',
      'release hand',
      'stretch fingers',
      'extend hand',
    ],
    'close_hand': [
      'fechar mao',
      'fecha mao',
      'fecha a mao',
      'fechar a mao',
      'feche a mao',
      'feche os dedos',
      'fecha os dedos',
      'fechar os dedos',
      'fechar todos os dedos',
      'fecha todos os dedos',
      'fazer punho',
      'faz punho',
      'fecha tudo',
      'fecha os dedos todos',
      'fecha a mao toda',
      'junta os dedos',
      'contrai a mao',
      'aperta a mao',
      'mao fechada',
      'punho fechado',
      'close hand',
      'close the hand',
      'make a fist',
      'closed fist',
      'squeeze hand',
      'close all fingers',
      'close the fingers',
    ],
    'two': [
      'numero dois',
      'numero 2',
      'dois',
      'dois dedos',
      'mostra dois',
      'mostra dois dedos',
      'faz dois',
      'faz o dois',
      'levanta dois dedos',
      'number two',
      'two',
      'two fingers',
      'show two',
    ],
    'peace': [
      'sinal de paz',
      'faz paz',
      'paz',
      'vitoria',
      'faz o v',
      'sinal v',
      'gesto v',
      'faz vitoria',
      'peace sign',
      'victory sign',
      'make a v',
      'v sign',
    ],
    'point': [
      'apontar',
      'aponta',
      'aponta com o dedo',
      'dedo indicador',
      'deixa so o indicador',
      'so o indicador',
      'aponta em frente',
      'aponta para frente',
      'indicador aberto',
      'numero um',
      'faz numero um',
      'point',
      'point finger',
      'index finger',
      'only index',
      'point forward',
      'number one',
    ],
    'three': [
      'tres dedos',
      'numero tres',
      'numero 3',
      'faz tres',
      'faz o tres',
      'mostra tres dedos',
      'levanta tres dedos',
      'abre tres dedos',
      'mostra o tres',
      'three fingers',
      'number three',
      'show three',
    ],
    'four': [
      'quatro dedos',
      'numero quatro',
      'numero 4',
      'quatro',
      'faz quatro',
      'faz o quatro',
      'mostra quatro',
      'mostra quatro dedos',
      'levanta quatro dedos',
      'four fingers',
      'number four',
      'show four',
    ],
    'thumbs_up': [
      'joinha',
      'joia',
      'faz joinha',
      'faz positivo',
      'sinal positivo',
      'polegar para cima',
      'dedao para cima',
      'fixe',
      'gosto',
      'like',
      'thumbs up',
      'positive sign',
      'thumb up',
    ],
    'ok': [
      'ok',
      'okay',
      'faz ok',
      'sinal de ok',
      'esta bem',
      'tudo bem',
      'certo',
      'perfeito',
      'confirmar',
      'confirma',
      'gesto ok',
      'okay sign',
    ],
    'wave': [
      'acenar',
      'acena',
      'dizer ola',
      'diz ola',
      'dizer adeus',
      'diz adeus',
      'cumprimentar',
      'manda ola',
      'diz xau',
      'ola',
      'adeus',
      'cumprimenta',
      'wave',
      'say hello',
      'say goodbye',
      'greet',
    ],
    'palm_up': [
      'palma para cima',
      'palma cima',
      'mao para cima',
      'vira a palma para cima',
      'vira para cima',
      'roda para cima',
      'supinacao',
      'palm up',
      'rotate up',
      'supination',
    ],
    'palm_down': [
      'palma para baixo',
      'palma baixo',
      'mao para baixo',
      'vira a palma para baixo',
      'vira para baixo',
      'roda para baixo',
      'pronacao',
      'palm down',
      'rotate down',
      'pronation',
    ],
    'forearm_neutral': [
      'antebraco neutro',
      'posicao neutra',
      'posicao normal',
      'volta ao normal',
      'voltar ao normal',
      'fica normal',
      'volta ao centro',
      'antebraco ao centro',
      'centro',
      'neutral position',
      'normal position',
      'center forearm',
      'return to center',
    ],
    'demo': [
      'demo',
      'demonstracao',
      'faz demonstracao',
      'modo demonstracao',
      'mostra tudo',
      'testa tudo',
      'testar movimentos',
      'faz o teste',
      'modo teste',
      'demo mode',
      'show everything',
      'test movements',
      'run demo',
    ],
    'open_index': [
      'abre o indicador',
      'abrir o indicador',
      'abre dedo indicador',
      'abre o dedo indicador',
      'abrir dedo indicador',
      'indicador aberto',
      'open index',
      'open index finger',
    ],
    'close_index': [
      'fecha o indicador',
      'fechar o indicador',
      'feche o indicador',
      'fecha dedo indicador',
      'fecha o dedo indicador',
      'fechar dedo indicador',
      'indicador fechado',
      'close index',
      'close index finger',
    ],
    'open_middle': [
      'abre o dedo medio',
      'abrir o dedo medio',
      'abre o medio',
      'abre dedo medio',
      'dedo medio aberto',
      'open middle finger',
      'open middle',
    ],
    'close_middle': [
      'fecha o dedo medio',
      'fechar o dedo medio',
      'feche o dedo medio',
      'fecha o medio',
      'fecha dedo medio',
      'dedo medio fechado',
      'close middle finger',
      'close middle',
    ],
    'open_ringpinky': [
      'abre o anelar e o mindinho',
      'abrir o anelar e o mindinho',
      'abre anelar e mindinho',
      'abre o mindinho e o anelar',
      'anelar e mindinho abertos',
      'open ring and pinky',
      'open ring pinky',
    ],
    'close_ringpinky': [
      'fecha o anelar e o mindinho',
      'fechar o anelar e o mindinho',
      'feche o anelar e o mindinho',
      'fecha anelar e mindinho',
      'fecha o mindinho e o anelar',
      'anelar e mindinho fechados',
      'close ring and pinky',
      'close ring pinky',
    ],
    'open_thumb': [
      'abre o polegar',
      'abrir o polegar',
      'abre o dedao',
      'abre dedao',
      'polegar aberto',
      'dedao aberto',
      'open thumb',
    ],
    'close_thumb': [
      'fecha o polegar',
      'fechar o polegar',
      'feche o polegar',
      'fecha o dedao',
      'fecha dedao',
      'polegar fechado',
      'dedao fechado',
      'close thumb',
    ],
  };

  static const Map<String, List<String>> keywords = {
    'open_hand': [
      'abrir',
      'abre',
      'aberta',
      'aberto',
      'estica',
      'esticar',
      'solta',
      'liberta',
      'estende',
      'dedos',
      'mao',
    ],
    'close_hand': [
      'fechar',
      'fecha',
      'fechada',
      'fechado',
      'punho',
      'aperta',
      'apertar',
      'contrai',
      'dedos',
      'mao',
    ],
    'two': [
      'dois',
      '2',
      'dedos',
      'numero',
      'two',
    ],
    'peace': [
      'paz',
      'vitoria',
      'v',
      'peace',
      'victory',
    ],
    'point': [
      'apontar',
      'aponta',
      'indicador',
      'frente',
      'dedo',
      'point',
      'index',
      'um',
    ],
    'three': [
      'tres',
      '3',
      'mostra',
      'dedos',
      'numero',
      'three',
    ],
    'four': [
      'quatro',
      '4',
      'mostra',
      'dedos',
      'numero',
      'four',
    ],
    'thumbs_up': [
      'joinha',
      'joia',
      'positivo',
      'like',
      'polegar',
      'dedao',
      'thumb',
      'cima',
      'fixe',
    ],
    'ok': [
      'ok',
      'okay',
      'certo',
      'perfeito',
      'bem',
      'confirmar',
      'confirma',
    ],
    'wave': [
      'acenar',
      'acena',
      'ola',
      'adeus',
      'cumprimenta',
      'cumprimentar',
      'wave',
      'hello',
      'goodbye',
    ],
    'palm_up': [
      'palma',
      'mao',
      'cima',
      'roda',
      'supinacao',
      'up',
    ],
    'palm_down': [
      'palma',
      'mao',
      'baixo',
      'roda',
      'pronacao',
      'down',
    ],
    'forearm_neutral': [
      'neutro',
      'neutra',
      'normal',
      'centro',
      'centraliza',
      'volta',
      'voltar',
      'posicao',
      'antebraco',
      'neutral',
    ],
    'demo': [
      'demo',
      'demonstracao',
      'mostra',
      'testa',
      'testar',
      'movimentos',
      'teste',
    ],
    'open_index': ['abrir', 'abre', 'indicador', 'index', 'open'],
    'close_index': ['fechar', 'fecha', 'indicador', 'index', 'close'],
    'open_middle': ['abrir', 'abre', 'medio', 'middle', 'open'],
    'close_middle': ['fechar', 'fecha', 'medio', 'middle', 'close'],
    'open_ringpinky': [
      'abrir',
      'abre',
      'anelar',
      'mindinho',
      'pinky',
      'ring',
      'open',
    ],
    'close_ringpinky': [
      'fechar',
      'fecha',
      'anelar',
      'mindinho',
      'pinky',
      'ring',
      'close',
    ],
    'open_thumb': ['abrir', 'abre', 'polegar', 'dedao', 'thumb', 'open'],
    'close_thumb': ['fechar', 'fecha', 'polegar', 'dedao', 'thumb', 'close'],
  };

  static const Map<String, List<String>> requiredAny = {
    'open_hand': [
      'abrir',
      'abre',
      'aberta',
      'aberto',
      'estica',
      'esticar',
      'solta',
      'liberta',
      'estende',
    ],
    'close_hand': [
      'fechar',
      'fecha',
      'fechada',
      'fechado',
      'punho',
      'aperta',
      'apertar',
      'contrai',
    ],
    'two': ['dois', '2', 'two'],
    'peace': ['paz', 'vitoria', 'v', 'peace', 'victory'],
    'point': ['apontar', 'aponta', 'indicador', 'point', 'index', 'um'],
    'three': ['tres', '3', 'three'],
    'four': ['quatro', '4', 'four'],
    'thumbs_up': ['joinha', 'joia', 'positivo', 'like', 'polegar', 'dedao', 'thumb', 'fixe'],
    'ok': ['ok', 'okay', 'certo', 'perfeito', 'confirmar', 'confirma'],
    'wave': ['acenar', 'acena', 'ola', 'adeus', 'cumprimenta', 'wave', 'hello', 'goodbye'],
    'palm_up': ['cima', 'roda', 'supinacao', 'up'],
    'palm_down': ['baixo', 'roda', 'pronacao', 'down'],
    'forearm_neutral': ['neutro', 'neutra', 'normal', 'centro', 'neutral'],
    'demo': ['demo', 'demonstracao', 'mostra', 'testa', 'testar', 'teste'],
    'open_index': ['indicador', 'index'],
    'close_index': ['indicador', 'index'],
    'open_middle': ['medio', 'middle'],
    'close_middle': ['medio', 'middle'],
    'open_ringpinky': ['anelar', 'mindinho', 'pinky', 'ring'],
    'close_ringpinky': ['anelar', 'mindinho', 'pinky', 'ring'],
    'open_thumb': ['polegar', 'dedao', 'thumb'],
    'close_thumb': ['polegar', 'dedao', 'thumb'],
  };

  static const Set<String> fillerWords = {
    'por',
    'favor',
    'podes',
    'pode',
    'podia',
    'consegue',
    'consegues',
    'quero',
    'queria',
    'faz',
    'fazer',
    'mete',
    'coloca',
    'deixa',
    'bota',
    'agora',
    'ai',
    'tipo',
    'assim',
    'me',
    'para',
    'se',
    'la',
    'o',
    'a',
    'os',
    'as',
    'ao',
    'um',
    'uma',
    'e',
    'pff',
    'porfavor',
    'please',
    'can',
    'you',
    'make',
    'do',
    'the',
    'an',
  };

  static const Map<String, String> replacements = {
    'maun': 'mao',
    'mão': 'mao',
    'maos': 'mao',
    'mãos': 'mao',
    'fexar': 'fechar',
    'fexa': 'fecha',
    'feixa': 'fecha',
    'feixar': 'fechar',
    'jóinha': 'joinha',
    'joínha': 'joinha',
    'join': 'joinha',
    'jóia': 'joia',
    'dedão': 'dedao',
    'médio': 'medio',
    'meio': 'medio',
    'indicado': 'indicador',
    'indica dor': 'indicador',
    'vitória': 'vitoria',
    'três': 'tres',
    'tree': 'three',
    'palm': 'palma',
    'pra': 'para',
    'xau': 'adeus',
    'chau': 'adeus',
    'tá': 'esta',
    'ta': 'esta',
    'num': 'numero',
  };

  static String classify(String text) {
    final cleanText = normalize(text);

    if (cleanText.isEmpty) {
      return 'unknown';
    }

    final scores = <String, double>{};

    for (final command in strongPhrases.keys) {
      scores[command] = _scoreCommand(cleanText, command);
    }

    final ranked = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final best = ranked[0];
    final second =
        ranked.length > 1 ? ranked[1] : const MapEntry('unknown', 0.0);

    if (best.value < 2.2) {
      return 'unknown';
    }

    if (second.value > 0 && best.value - second.value < 0.45) {
      return 'unknown';
    }

    return best.key;
  }

  static String normalize(String text) {
    var value = text.toLowerCase().trim();

    value = _removeAccents(value);

    for (final entry in replacements.entries) {
      final wrong = _removeAccents(entry.key.toLowerCase());
      final right = _removeAccents(entry.value.toLowerCase());
      value = value.replaceAll(RegExp('\\b${RegExp.escape(wrong)}\\b'), right);
    }

    value = value.replaceAll(RegExp(r'[^a-z0-9\s]'), ' ');
    value = value.replaceAll(RegExp(r'\s+'), ' ').trim();

    return value;
  }

  static List<String> _tokens(String text) {
    return normalize(text)
        .split(' ')
        .where((word) => word.isNotEmpty && !fillerWords.contains(word))
        .toList();
  }

  static double _scoreCommand(String cleanText, String command) {
    final inputTokens = _tokens(cleanText);
    var score = 0.0;

    final phrases = strongPhrases[command] ?? [];
    final commandKeywords = keywords[command] ?? [];

    for (final phrase in phrases) {
      final cleanPhrase = normalize(phrase);

      if (cleanText.contains(cleanPhrase)) {
        score += 3.0;
      }

      final phraseScore = _similarity(cleanText, cleanPhrase);

      if (phraseScore >= 0.75) {
        score += phraseScore * 2.5;
      }

      final overlap = _tokenOverlapScore(inputTokens, _tokens(cleanPhrase));
      score += overlap * 2.0;
    }

    for (final keyword in commandKeywords) {
      final cleanKeyword = normalize(keyword);

      for (final word in inputTokens) {
        final sim = _similarity(word, cleanKeyword);

        if (word == cleanKeyword) {
          score += 0.9;
        } else if (sim >= 0.82) {
          score += 0.6;
        } else if (sim >= 0.72) {
          score += 0.3;
        }
      }
    }

    if (!_containsRequiredWord(inputTokens, requiredAny[command] ?? [])) {
      score *= 0.35;
    }

    final joined = inputTokens.join(' ');
    final fingerWords = [
      'indicador',
      'medio',
      'anelar',
      'mindinho',
      'polegar',
      'dedao',
      'index',
      'middle',
      'ring',
      'pinky',
      'thumb',
    ];

    if (command == 'open_hand' &&
        _hasAny(joined, ['fechar', 'fecha', 'punho', 'fechada'])) {
      score *= 0.25;
    }

    if (command == 'close_hand' &&
        _hasAny(joined, ['abrir', 'abre', 'aberta', 'estica'])) {
      score *= 0.25;
    }

    if ((command == 'open_hand' || command == 'close_hand') &&
        _hasAny(joined, fingerWords) &&
        !_hasAny(joined, ['todos', 'tudo', 'mao', 'dedos'])) {
      score *= 0.25;
    }

    if (command == 'palm_up' && joined.contains('baixo')) {
      score *= 0.1;
    }

    if (command == 'palm_down' && joined.contains('cima')) {
      score *= 0.1;
    }

    if (command == 'peace' && _hasAny(joined, ['dois', '2', 'tres', '3', 'quatro', '4'])) {
      score *= 0.3;
    }

    if (command == 'two' && _hasAny(joined, ['paz', 'vitoria', 'tres', '3', 'quatro', '4'])) {
      score *= 0.3;
    }

    if (command == 'three' &&
        _hasAny(joined, ['dois', '2', 'paz', 'vitoria', 'quatro', '4'])) {
      score *= 0.3;
    }

    if (command == 'four' && _hasAny(joined, ['dois', '2', 'tres', '3', 'paz', 'vitoria'])) {
      score *= 0.3;
    }

    if (command == 'thumbs_up' && joined.contains('palma')) {
      score *= 0.35;
    }

    if (command == 'palm_up' && _hasAny(joined, ['joinha', 'polegar', 'thumb'])) {
      score *= 0.35;
    }

    if (command.startsWith('open_') &&
        !command.contains('hand') &&
        _hasAny(joined, ['fechar', 'fecha', 'feche'])) {
      score *= 0.3;
    }

    if (command.startsWith('close_') &&
        !command.contains('hand') &&
        _hasAny(joined, ['abrir', 'abre'])) {
      score *= 0.3;
    }

    return score;
  }

  static bool _containsRequiredWord(
    List<String> inputTokens,
    List<String> requiredWords,
  ) {
    if (requiredWords.isEmpty) return true;

    for (final required in requiredWords) {
      final cleanRequired = normalize(required);

      for (final word in inputTokens) {
        if (word == cleanRequired || _similarity(word, cleanRequired) >= 0.82) {
          return true;
        }
      }
    }

    return false;
  }

  static bool _hasAny(String text, List<String> words) {
    return words.any(text.contains);
  }

  static double _tokenOverlapScore(
    List<String> inputTokens,
    List<String> patternTokens,
  ) {
    if (patternTokens.isEmpty) return 0.0;

    var score = 0.0;

    for (final pattern in patternTokens) {
      var best = 0.0;

      for (final token in inputTokens) {
        best = max(best, _similarity(token, pattern));
      }

      if (best >= 0.82) {
        score += 1.0;
      } else if (best >= 0.68) {
        score += 0.6;
      }
    }

    return score / patternTokens.length;
  }

  static double _similarity(String a, String b) {
    if (a == b) return 1.0;
    if (a.isEmpty || b.isEmpty) return 0.0;

    final matrix = List.generate(
      a.length + 1,
      (_) => List<int>.filled(b.length + 1, 0),
    );

    for (var i = 0; i <= a.length; i++) {
      matrix[i][0] = i;
    }

    for (var j = 0; j <= b.length; j++) {
      matrix[0][j] = j;
    }

    for (var i = 1; i <= a.length; i++) {
      for (var j = 1; j <= b.length; j++) {
        final cost = a[i - 1] == b[j - 1] ? 0 : 1;

        matrix[i][j] = min(
          min(
            matrix[i - 1][j] + 1,
            matrix[i][j - 1] + 1,
          ),
          matrix[i - 1][j - 1] + cost,
        );
      }
    }

    final distance = matrix[a.length][b.length];
    final maxLength = max(a.length, b.length);

    return 1.0 - distance / maxLength;
  }

  static String _removeAccents(String text) {
    const from = 'áàãâäéèêëíìîïóòõôöúùûüçñ';
    const to = 'aaaaaeeeeiiiiooooouuuucn';

    var result = text;

    for (var i = 0; i < from.length; i++) {
      result = result.replaceAll(from[i], to[i]);
    }

    return result;
  }
}
