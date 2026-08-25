import 'app_language.dart';

class L10n {
  const L10n(this.language);

  final AppLanguage language;
  bool get isPt => language == AppLanguage.portuguese;

  String get home => isPt ? 'Início' : 'Home';
  String get settings => isPt ? 'Configurações' : 'Settings';
  String get configShort => isPt ? 'Config' : 'Settings';
  String get appVersion => isPt ? 'Versão da app' : 'App version';
  String get serviceTerms =>
      isPt ? 'Termos de serviço 🔗' : 'Terms of service 🔗';
  String get appName => 'ARMIAC';
  String get appSubtitle =>
      isPt ? 'Mão robótica inteligente' : 'Intelligent robotic hand';
  String get languageLabel => isPt
      ? 'Idioma da app e comandos de voz'
      : 'App and voice command language';
  String get portuguese => 'Português';
  String get english => 'English';
  String get languageHelp => isPt
      ? 'Ao escolher português, a app fala, escuta e entende comandos em português.'
      : 'When English is selected, the app speaks, listens, and understands English commands.';
  String get microphonePermission =>
      isPt ? 'Permissão do microfone' : 'Microphone permission';
  String get microphonePermissionBody => isPt
      ? 'Ative a permissão do microfone nas definições do telemóvel para usar comandos por voz.'
      : 'Enable microphone permission in your phone settings to use voice commands.';
  String get armiacConnection =>
      isPt ? 'Ligação ao ARMIAC' : 'ARMIAC connection';
  String get armiacConnectionBody => isPt
      ? 'Ligue o ARMIAC à corrente, conecte o telemóvel ao Wi‑Fi “ARMIAC” e depois toque em “Conectar ao ARMIAC”.'
      : 'Plug the ARMIAC into power, connect your phone to the “ARMIAC” Wi‑Fi, and then tap “Connect to ARMIAC”.';
  String get connected => isPt ? 'ARMIAC Conectado' : 'ARMIAC Connected';
  String get disconnected =>
      isPt ? 'ARMIAC Desconectado' : 'ARMIAC Disconnected';
  String get connecting => isPt ? 'Conectando...' : 'Connecting...';
  String get connectArmiac =>
      isPt ? 'Conectar ao ARMIAC' : 'Connect to ARMIAC';
  String get stopVoice => isPt ? 'Parar voz' : 'Stop voice';
  String get voiceControl => isPt ? 'Controlo por voz' : 'Voice control';
  String get voice => isPt ? 'Voz' : 'Voice';
  String get manualControl =>
      isPt ? 'Painel de movimentos' : 'Movement panel';
  String get quickCommands => isPt ? 'Comandos rápidos' : 'Quick commands';
  String get tutorial => isPt ? 'Tutorial rápido' : 'Quick tutorial';
  String get tutorialTitle => isPt ? 'Como usar o ARMIAC' : 'How to use ARMIAC';
  String get tutorialStep1Title => isPt ? '1. Ligar o ARMIAC' : '1. Power on ARMIAC';
  String get tutorialStep1Body => isPt
      ? 'Ligue o ARMIAC à corrente para o deixar pronto a funcionar.'
      : 'Plug the ARMIAC into power so it is ready to work.';
  String get tutorialStep2Title =>
      isPt ? '2. Conectar e usar' : '2. Connect and use';
  String get tutorialStep2Body => isPt
      ? 'Conecte-se à rede Wi‑Fi “ARMIAC” e toque no botão “Conectar ao ARMIAC” na app.'
      : 'Connect to the “ARMIAC” Wi‑Fi network and tap “Connect to ARMIAC” in the app.';
  String get previous => isPt ? 'Anterior' : 'Back';
  String get next => isPt ? 'Seguinte' : 'Next';
  String get finish => isPt ? 'Fechar' : 'Close';
  String get connectedSnack =>
      isPt ? 'Conectado ao ARMIAC' : 'Connected to ARMIAC';
  String get connectFirst => isPt
      ? 'Conecte-se primeiro ao Wi‑Fi do ARMIAC.'
      : 'Connect to the ARMIAC Wi‑Fi first.';
  String get micUnavailable => isPt
      ? 'Microfone indisponível ou sem permissão.'
      : 'Microphone unavailable or permission denied.';
  String get listening => isPt ? 'Estou a ouvir...' : 'Listening...';
  String get speechNetworkError => isPt
      ? 'Internet desativada. Para usar voz em português sem internet, instale Português no reconhecimento de voz do telemóvel.'
      : 'Internet disabled. To use voice commands without internet, install the selected language in your phone voice recognition settings.';
  String get speechLanguageError => isPt
      ? 'O português offline deste telemóvel está como Português (Brasil). A app vai tentar usar pt_BR.'
      : 'English is not available in this phone voice recognition. Enable or install English in the voice settings.';
  String micError(String error) =>
      isPt ? 'Erro no microfone: $error' : 'Microphone error: $error';
  String error(Object e) => isPt ? 'Erro: $e' : 'Error: $e';
  String get actionFailed => isPt
      ? 'Falha ao enviar comando ao ARMIAC.'
      : 'Failed to send command to ARMIAC.';
  String commandUnderstood(String spoken) =>
      isPt ? 'Comando entendido: $spoken' : 'Command understood: $spoken';
  String get didNotUnderstand =>
      isPt ? 'Não entendi o comando' : 'I did not understand the command';
  String get didNotUnderstandText => isPt
      ? 'Não entendi. Abra a ajuda para ver comandos disponíveis.'
      : 'I did not understand. Open help to see available commands.';
  String get help => isPt ? 'Ajuda' : 'Help';
  String get commandsHelp => isPt ? 'Comandos rápidos' : 'Quick commands';
  String get commandsHelpIntro => isPt
      ? 'Pode falar de forma curta ou natural. A app tenta entender várias formas de dizer o mesmo comando.'
      : 'You can speak in a short or natural way. The app tries to understand many ways of saying the same command.';
  List<String> get commandHelpItems => isPt
      ? [
          'Mão aberta: abrir mão, abre a mão, abre os dedos, estica os dedos, deixa a mão aberta',
          'Fechar mão: fechar mão, fecha a mão, feche os dedos, fecha os dedos, faz punho',
          'Número 2: número dois, dois dedos, mostra dois dedos',
          'Símbolo paz: paz, vitória, dois dedos, faz o V',
          'Apontar: apontar, aponta, só o indicador, número um',
          'Número 3: número três, três dedos, faz três, mostra três dedos',
          'Número 4: número quatro, quatro dedos, mostra quatro dedos',
          'Joinha: joinha, fixe, positivo, polegar para cima',
          'OK: ok, está bem, certo, perfeito',
          'Acenar: acenar, olá, adeus, cumprimenta',
          'Palma para cima: palma para cima, vira para cima',
          'Palma para baixo: palma para baixo, vira para baixo',
          'Antebraço ao centro: posição neutra, volta ao centro, antebraço neutro',
          'Demonstração: demonstração, mostra tudo, testa movimentos',
          'Indicador: abre o indicador, fecha o indicador',
          'Dedo médio: abre o dedo médio, fecha o dedo médio',
          'Anelar + mindinho: abre o anelar e o mindinho, fecha o anelar e o mindinho',
          'Polegar: abre o polegar, fecha o polegar',
        ]
      : [
          'Open hand: open hand, open the hand, open fingers, stretch fingers',
          'Close hand: close hand, close the fingers, make a fist, squeeze hand',
          'Number 2: number two, two fingers, show two fingers',
          'Peace sign: peace, victory, two fingers, make a V',
          'Point: point, only index, number one, point forward',
          'Number 3: number three, three fingers, show three',
          'Number 4: number four, four fingers, show four fingers',
          'Thumbs up: thumbs up, like, positive sign',
          'OK: ok, okay, perfect',
          'Wave: wave, hello, bye, greet',
          'Palm up: palm up, face up, rotate up',
          'Palm down: palm down, face down, rotate down',
          'Forearm center: neutral forearm, return to center',
          'Demo: demo, demonstration, show everything',
          'Index finger: open index, close index',
          'Middle finger: open middle finger, close middle finger',
          'Ring + pinky: open ring and pinky, close ring and pinky',
          'Thumb: open thumb, close thumb',
        ];

  String get open => isPt ? 'Abrir' : 'Open';
  String get close => isPt ? 'Fechar' : 'Close';
  String get peace => isPt ? 'Paz' : 'Peace';
  String get point => isPt ? 'Apontar' : 'Point';
  String get thumbsUp => isPt ? 'Joinha' : 'Thumbs up';
  String get wave => isPt ? 'Acenar' : 'Wave';
  String get palmUpShort => isPt ? 'Palma cima' : 'Palm up';
  String get palmDownShort => isPt ? 'Palma baixo' : 'Palm down';
  String get handControl =>
      isPt ? 'Painel de movimentos' : 'Movement panel';
  String get connectedToArmiac =>
      isPt ? 'Ligado ao ARMIAC' : 'Connected to ARMIAC';
  String get notConnectedToArmiac =>
      isPt ? 'Não ligado ao ARMIAC' : 'Not connected to ARMIAC';
  String get status => isPt ? 'Estado' : 'Status';
  String get forearm => isPt ? 'Antebraço' : 'Forearm';
  String get openCloseHand =>
      isPt ? 'Abrir / fechar mão' : 'Open / close hand';
  String get closeHand => isPt ? 'Fechar mão' : 'Close hand';
  String get peaceSign => isPt ? 'Símbolo paz' : 'Peace sign';
  String get numberTwo => isPt ? 'Número 2' : 'Number 2';
  String get numberThree => isPt ? 'Número 3' : 'Number 3';
  String get numberFour => isPt ? 'Número 4' : 'Number 4';
  String get okSign => 'OK';
  String get palmUp => isPt ? 'Palma para cima' : 'Palm up';
  String get palmDown => isPt ? 'Palma para baixo' : 'Palm down';
  String get forearmNeutral =>
      isPt ? 'Antebraço ao centro' : 'Forearm center';
  String get automaticDemo =>
      isPt ? 'Demonstração automática' : 'Automatic demo';
  String get indexFinger => isPt ? 'Dedo indicador' : 'Index finger';
  String get middleFinger => isPt ? 'Dedo médio' : 'Middle finger';
  String get ringPinky =>
      isPt ? 'Dedo anelar + mindinho' : 'Ring + pinky fingers';
  String get thumb => isPt ? 'Dedão' : 'Thumb';

  String get openHandState => isPt ? 'Mão aberta' : 'Open hand';
  String get closedFistState => isPt ? 'Punho fechado' : 'Closed fist';
  String get demoState => isPt ? 'Demonstração' : 'Demo';
  String get palmUpState => isPt ? 'Palma para cima' : 'Palm up';
  String get palmDownState => isPt ? 'Palma para baixo' : 'Palm down';
  String get forearmCenterState =>
      isPt ? 'Antebraço ao centro' : 'Forearm center';
  String get indexClosed => isPt ? 'Indicador fechado' : 'Index closed';
  String get indexOpen => isPt ? 'Indicador aberto' : 'Index open';
  String get middleClosed =>
      isPt ? 'Dedo médio fechado' : 'Middle finger closed';
  String get middleOpen => isPt ? 'Dedo médio aberto' : 'Middle finger open';
  String get ringPinkyClosed =>
      isPt ? 'Anelar + mindinho fechados' : 'Ring + pinky closed';
  String get ringPinkyOpen =>
      isPt ? 'Anelar + mindinho abertos' : 'Ring + pinky open';
  String get thumbClosed => isPt ? 'Polegar fechado' : 'Thumb closed';
  String get thumbOpen => isPt ? 'Polegar aberto' : 'Thumb open';

  String speechFor(
    String command, {
    bool indexClosed = false,
    bool middleClosed = false,
    bool ringPinkyClosed = false,
    bool thumbClosed = false,
  }) {
    switch (command) {
      case 'open_hand':
        return isPt ? 'vou abrir a mão' : 'opening the hand';
      case 'close_hand':
        return isPt ? 'vou fechar a mão' : 'closing the hand';
      case 'peace':
        return isPt ? 'vou fazer o gesto de paz' : 'making the peace sign';
      case 'two':
        return isPt ? 'vou mostrar o número dois' : 'showing number two';
      case 'point':
        return isPt
            ? 'vou apontar com o indicador'
            : 'pointing with the index finger';
      case 'three':
        return isPt ? 'vou mostrar o número três' : 'showing number three';
      case 'four':
        return isPt ? 'vou mostrar o número quatro' : 'showing number four';
      case 'thumbs_up':
        return isPt ? 'vou fazer joinha' : 'making a thumbs up';
      case 'ok':
        return isPt ? 'vou fazer o gesto ok' : 'making the OK sign';
      case 'wave':
        return isPt ? 'vou acenar' : 'waving';
      case 'palm_up':
        return isPt ? 'vou virar a palma para cima' : 'turning the palm up';
      case 'palm_down':
        return isPt ? 'vou virar a palma para baixo' : 'turning the palm down';
      case 'forearm_neutral':
        return isPt
            ? 'vou pôr o antebraço ao centro'
            : 'moving the forearm to the center';
      case 'demo':
        return isPt ? 'vou fazer a demonstração' : 'starting the demonstration';
      case 'open_index':
        return isPt ? 'vou abrir o indicador' : 'opening the index finger';
      case 'close_index':
        return isPt ? 'vou fechar o indicador' : 'closing the index finger';
      case 'open_middle':
        return isPt ? 'vou abrir o dedo médio' : 'opening the middle finger';
      case 'close_middle':
        return isPt ? 'vou fechar o dedo médio' : 'closing the middle finger';
      case 'open_ringpinky':
        return isPt
            ? 'vou abrir o anelar e o mindinho'
            : 'opening the ring and pinky fingers';
      case 'close_ringpinky':
        return isPt
            ? 'vou fechar o anelar e o mindinho'
            : 'closing the ring and pinky fingers';
      case 'open_thumb':
        return isPt ? 'vou abrir o polegar' : 'opening the thumb';
      case 'close_thumb':
        return isPt ? 'vou fechar o polegar' : 'closing the thumb';
      case 'toggle_index':
        return isPt
            ? (indexClosed ? 'vou abrir o indicador' : 'vou fechar o indicador')
            : (indexClosed
                  ? 'opening the index finger'
                  : 'closing the index finger');
      case 'toggle_middle':
        return isPt
            ? (middleClosed
                  ? 'vou abrir o dedo médio'
                  : 'vou fechar o dedo médio')
            : (middleClosed
                  ? 'opening the middle finger'
                  : 'closing the middle finger');
      case 'toggle_ring_pinky':
        return isPt
            ? (ringPinkyClosed
                  ? 'vou abrir o anelar e o mindinho'
                  : 'vou fechar o anelar e o mindinho')
            : (ringPinkyClosed
                  ? 'opening the ring and pinky fingers'
                  : 'closing the ring and pinky fingers');
      case 'toggle_thumb':
        return isPt
            ? (thumbClosed ? 'vou abrir o polegar' : 'vou fechar o polegar')
            : (thumbClosed ? 'opening the thumb' : 'closing the thumb');
    }
    return '';
  }

  String get termsTitle => isPt ? 'Termos de Serviço' : 'Terms of Service';
  String get termsHeader =>
      isPt ? 'TERMOS DE SERVIÇO – ARMIAC' : 'TERMS OF SERVICE – ARMIAC';
  String get lastUpdate => isPt
      ? 'Última atualização: Maio de 2026'
      : 'Last updated: May 2026';
  List<String> get termsParagraphs => isPt
      ? [
          'ARMIAC é um projeto independente desenvolvido por Quévin Leonardo Aguiar Tavares em Portugal.',
          'A aplicação permite aos utilizadores controlar funcionalidades digitais e comandos ligados à mão robótica ARMIAC.',
          'O utilizador deve usar a aplicação de forma responsável, segura e de acordo com a lei.',
          'O nome, logótipo, design, código e identidade visual ARMIAC pertencem ao proprietário do projeto.',
          'A ARMIAC respeita a privacidade do utilizador e procura processar dados pessoais de forma segura, em conformidade com o RGPD quando aplicável.',
          'Use os comandos da mão robótica com cuidado. O utilizador é responsável por testar o sistema num ambiente seguro.',
          'Contacto: kevinleonardomail@gmail.com | Website: https://kevinleonardohub.github.io/portfolio',
        ]
      : [
          'ARMIAC is an independent project developed by Quévin Leonardo Aguiar Tavares in Portugal.',
          'The application allows users to control digital features and commands linked to the ARMIAC robotic hand.',
          'The user must use the application responsibly, safely, and in accordance with the law.',
          'The ARMIAC name, logo, design, code, and visual identity belong to the project owner.',
          'ARMIAC respects user privacy and aims to process personal data securely, in line with GDPR when applicable.',
          'Use robotic hand commands carefully. The user is responsible for testing the system in a safe environment.',
          'Contact: kevinleonardomail@gmail.com | Website: https://kevinleonardohub.github.io/portfolio',
        ];

  String get speechServerDisconnectedError => isPt
      ? 'O motor de voz desligou neste telemóvel. A app vai tentar sem forçar o modo local. Toque novamente em Controlo por voz.'
      : 'The voice engine disconnected on this phone. The app will try without forcing local mode. Tap Voice control again.';
}
