import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:shared_preferences/shared_preferences.dart';

import '../app_language.dart';
import '../l10n.dart';
import '../services/esp32_wifi_service.dart';
import '../services/local_command_ai_service.dart';
import 'control_page.dart';
import 'tutorial_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum _ArmiacCommand {
  openHand,
  closeHand,
  peace,
  two,
  point,
  three,
  four,
  thumbsUp,
  ok,
  wave,
  palmUp,
  palmDown,
  forearmNeutral,
  demo,
  openIndex,
  closeIndex,
  openMiddle,
  closeMiddle,
  openRingPinky,
  closeRingPinky,
  openThumb,
  closeThumb,
}

class _HomePageState extends State<HomePage> {
  bool _loading = false;
  bool _listening = false;
  bool _demoRunning = false;
  String _lastVoiceText = '';
  String _aiFeedback = '';

  stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();

  bool handClosed = false;
  bool peaceMode = false;
  bool indexClosed = false;
  bool middleClosed = false;
  bool ringPinkyClosed = false;
  bool thumbClosed = false;
  String forearmKey = 'forearm_neutral';

  @override
  void initState() {
    super.initState();
    _configureTts();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openTutorialOnce();
    });
  }

  @override
  void dispose() {
    _speech.stop();
    _tts.stop();
    super.dispose();
  }

  L10n get _l10n => L10n(appSettings.language);

  Future<void> _configureTts() async {
    await _tts.setLanguage(appSettings.language.ttsLocale);
    await _tts.setSpeechRate(0.9);
    await _tts.setPitch(1.0);
    await _tts.awaitSpeakCompletion(true);
  }

  Future<void> _speakFast(String text) async {
    await _tts.stop();
    await _configureTts();
    await _tts.speak(text);
  }

  Future<void> _openTutorialOnce() async {
    final prefs = await SharedPreferences.getInstance();
    final alreadyShown = prefs.getBool('tutorial_shown_v1_1_4') ?? false;

    if (!mounted || alreadyShown) return;

    await prefs.setBool('tutorial_shown_v1_1_4', true);
    _openTutorial();
  }

  void _openTutorial() {
    showDialog<void>(
      context: context,
      builder: (_) => const TutorialDialog(),
    );
  }

  Future<void> _connect() async {
    setState(() => _loading = true);
    try {
      await Esp32WifiService.instance.connect();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_l10n.connectedSnack)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_l10n.connectFirst)));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<bool> _send(String action) async {
    if (!Esp32WifiService.instance.isConnected.value) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_l10n.connectFirst)));
      return false;
    }

    try {
      await Esp32WifiService.instance.action(action);
      return true;
    } catch (e) {
      if (!mounted) return false;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_l10n.actionFailed)));
      return false;
    }
  }

  void _setOpenHand() {
    handClosed = false;
    peaceMode = false;
    indexClosed = false;
    middleClosed = false;
    ringPinkyClosed = false;
    thumbClosed = false;
  }

  void _setClosedHand() {
    handClosed = true;
    peaceMode = false;
    indexClosed = true;
    middleClosed = true;
    ringPinkyClosed = true;
    thumbClosed = true;
  }

  void _applyGestureState(String action) {
    switch (action) {
      case 'open_hand':
        _setOpenHand();
        break;
      case 'close_hand':
        _setClosedHand();
        break;
      case 'peace':
        handClosed = false;
        peaceMode = true;
        indexClosed = false;
        middleClosed = false;
        ringPinkyClosed = true;
        thumbClosed = true;
        break;
      case 'two':
        handClosed = false;
        peaceMode = false;
        indexClosed = false;
        middleClosed = false;
        ringPinkyClosed = true;
        thumbClosed = true;
        break;
      case 'point':
        handClosed = false;
        peaceMode = false;
        indexClosed = false;
        middleClosed = true;
        ringPinkyClosed = true;
        thumbClosed = true;
        break;
      case 'three':
        handClosed = false;
        peaceMode = false;
        indexClosed = false;
        middleClosed = false;
        ringPinkyClosed = true;
        thumbClosed = false;
        break;
      case 'four':
        handClosed = false;
        peaceMode = false;
        indexClosed = false;
        middleClosed = false;
        ringPinkyClosed = false;
        thumbClosed = true;
        break;
      case 'thumbs_up':
        handClosed = false;
        peaceMode = false;
        indexClosed = true;
        middleClosed = true;
        ringPinkyClosed = true;
        thumbClosed = false;
        break;
      case 'ok':
        handClosed = false;
        peaceMode = false;
        indexClosed = true;
        middleClosed = false;
        ringPinkyClosed = false;
        thumbClosed = false;
        break;
      case 'wave':
        _setOpenHand();
        break;
      case 'palm_up':
      case 'palm_down':
      case 'forearm_neutral':
        forearmKey = action;
        break;
      case 'demo':
        break;
    }
  }

  Future<bool> _sendGestureAndUpdate(String action) async {
    final ok = await _send(action);
    if (!ok || !mounted) return false;
    setState(() => _applyGestureState(action));
    return true;
  }

  Future<void> _runGesture(String action) async {
    if (_demoRunning) return;

    if (action == 'demo') {
      await _runDemo();
      return;
    }

    if (action == 'wave') {
      final opened = await _sendGestureAndUpdate('open_hand');
      if (!opened) return;
      await Future<void>.delayed(const Duration(milliseconds: 180));
      await _sendGestureAndUpdate('wave');
      return;
    }

    final sent = await _sendGestureAndUpdate(action);
    if (!sent || !mounted) return;

    final isHandGesture = !{
      'palm_up',
      'palm_down',
      'forearm_neutral',
    }.contains(action);

    if (isHandGesture && forearmKey != 'forearm_neutral') {
      await Future<void>.delayed(const Duration(milliseconds: 120));
      await _send(forearmKey);
    }
  }

  Future<void> _runDemo() async {
    if (_demoRunning) return;
    setState(() => _demoRunning = true);

    final sequence = [
      'open_hand',
      'palm_up',
      'peace',
      'two',
      'palm_down',
      'point',
      'forearm_neutral',
      'three',
      'four',
      'palm_up',
      'thumbs_up',
      'palm_down',
      'ok',
      'forearm_neutral',
      // A acenação é feita apenas com a mão aberta.
      'open_hand',
      'wave',
      'forearm_neutral',
      'open_hand',
    ];

    for (final action in sequence) {
      if (!mounted) return;
      final ok = await _sendGestureAndUpdate(action);
      if (!ok) break;
      await Future<void>.delayed(const Duration(milliseconds: 450));
    }

    if (mounted) {
      setState(() => _demoRunning = false);
    }
  }

  Future<void> _runFingerAction(String action) async {
    final ok = await _send(action);
    if (!ok || !mounted) return;

    setState(() {
      handClosed = false;
      peaceMode = false;

      switch (action) {
        case 'open_index':
          indexClosed = false;
          break;
        case 'close_index':
          indexClosed = true;
          break;
        case 'open_middle':
          middleClosed = false;
          break;
        case 'close_middle':
          middleClosed = true;
          break;
        case 'open_ringpinky':
          ringPinkyClosed = false;
          break;
        case 'close_ringpinky':
          ringPinkyClosed = true;
          break;
        case 'open_thumb':
          thumbClosed = false;
          break;
        case 'close_thumb':
          thumbClosed = true;
          break;
      }
    });

    if (forearmKey != 'forearm_neutral') {
      await Future<void>.delayed(const Duration(milliseconds: 120));
      await _send(forearmKey);
    }
  }

  Future<void> _toggleHand() async {
    await _runGesture(handClosed ? 'open_hand' : 'close_hand');
  }

  Future<void> _executeCommand(_ArmiacCommand command) async {
    switch (command) {
      case _ArmiacCommand.openHand:
        await _runGesture('open_hand');
        break;
      case _ArmiacCommand.closeHand:
        await _runGesture('close_hand');
        break;
      case _ArmiacCommand.peace:
        await _runGesture('peace');
        break;
      case _ArmiacCommand.two:
        await _runGesture('two');
        break;
      case _ArmiacCommand.point:
        await _runGesture('point');
        break;
      case _ArmiacCommand.three:
        await _runGesture('three');
        break;
      case _ArmiacCommand.four:
        await _runGesture('four');
        break;
      case _ArmiacCommand.thumbsUp:
        await _runGesture('thumbs_up');
        break;
      case _ArmiacCommand.ok:
        await _runGesture('ok');
        break;
      case _ArmiacCommand.wave:
        await _runGesture('wave');
        break;
      case _ArmiacCommand.palmUp:
        await _runGesture('palm_up');
        break;
      case _ArmiacCommand.palmDown:
        await _runGesture('palm_down');
        break;
      case _ArmiacCommand.forearmNeutral:
        await _runGesture('forearm_neutral');
        break;
      case _ArmiacCommand.demo:
        await _runGesture('demo');
        break;
      case _ArmiacCommand.openIndex:
        await _runFingerAction('open_index');
        break;
      case _ArmiacCommand.closeIndex:
        await _runFingerAction('close_index');
        break;
      case _ArmiacCommand.openMiddle:
        await _runFingerAction('open_middle');
        break;
      case _ArmiacCommand.closeMiddle:
        await _runFingerAction('close_middle');
        break;
      case _ArmiacCommand.openRingPinky:
        await _runFingerAction('open_ringpinky');
        break;
      case _ArmiacCommand.closeRingPinky:
        await _runFingerAction('close_ringpinky');
        break;
      case _ArmiacCommand.openThumb:
        await _runFingerAction('open_thumb');
        break;
      case _ArmiacCommand.closeThumb:
        await _runFingerAction('close_thumb');
        break;
    }
  }

  _ArmiacCommand? _commandFromAction(String action) {
    switch (action) {
      case 'open_hand':
        return _ArmiacCommand.openHand;
      case 'close_hand':
        return _ArmiacCommand.closeHand;
      case 'peace':
        return _ArmiacCommand.peace;
      case 'two':
        return _ArmiacCommand.two;
      case 'point':
        return _ArmiacCommand.point;
      case 'three':
        return _ArmiacCommand.three;
      case 'four':
        return _ArmiacCommand.four;
      case 'thumbs_up':
        return _ArmiacCommand.thumbsUp;
      case 'ok':
        return _ArmiacCommand.ok;
      case 'wave':
        return _ArmiacCommand.wave;
      case 'palm_up':
        return _ArmiacCommand.palmUp;
      case 'palm_down':
        return _ArmiacCommand.palmDown;
      case 'forearm_neutral':
        return _ArmiacCommand.forearmNeutral;
      case 'demo':
        return _ArmiacCommand.demo;
      case 'open_index':
        return _ArmiacCommand.openIndex;
      case 'close_index':
        return _ArmiacCommand.closeIndex;
      case 'open_middle':
        return _ArmiacCommand.openMiddle;
      case 'close_middle':
        return _ArmiacCommand.closeMiddle;
      case 'open_ringpinky':
        return _ArmiacCommand.openRingPinky;
      case 'close_ringpinky':
        return _ArmiacCommand.closeRingPinky;
      case 'open_thumb':
        return _ArmiacCommand.openThumb;
      case 'close_thumb':
        return _ArmiacCommand.closeThumb;
    }
    return null;
  }

  String _commandToSpeech(_ArmiacCommand command) {
    switch (command) {
      case _ArmiacCommand.openHand:
        return _l10n.speechFor('open_hand');
      case _ArmiacCommand.closeHand:
        return _l10n.speechFor('close_hand');
      case _ArmiacCommand.peace:
        return _l10n.speechFor('peace');
      case _ArmiacCommand.two:
        return _l10n.speechFor('two');
      case _ArmiacCommand.point:
        return _l10n.speechFor('point');
      case _ArmiacCommand.three:
        return _l10n.speechFor('three');
      case _ArmiacCommand.four:
        return _l10n.speechFor('four');
      case _ArmiacCommand.thumbsUp:
        return _l10n.speechFor('thumbs_up');
      case _ArmiacCommand.ok:
        return _l10n.speechFor('ok');
      case _ArmiacCommand.wave:
        return _l10n.speechFor('wave');
      case _ArmiacCommand.palmUp:
        return _l10n.speechFor('palm_up');
      case _ArmiacCommand.palmDown:
        return _l10n.speechFor('palm_down');
      case _ArmiacCommand.forearmNeutral:
        return _l10n.speechFor('forearm_neutral');
      case _ArmiacCommand.demo:
        return _l10n.speechFor('demo');
      case _ArmiacCommand.openIndex:
        return _l10n.speechFor('open_index');
      case _ArmiacCommand.closeIndex:
        return _l10n.speechFor('close_index');
      case _ArmiacCommand.openMiddle:
        return _l10n.speechFor('open_middle');
      case _ArmiacCommand.closeMiddle:
        return _l10n.speechFor('close_middle');
      case _ArmiacCommand.openRingPinky:
        return _l10n.speechFor('open_ringpinky');
      case _ArmiacCommand.closeRingPinky:
        return _l10n.speechFor('close_ringpinky');
      case _ArmiacCommand.openThumb:
        return _l10n.speechFor('open_thumb');
      case _ArmiacCommand.closeThumb:
        return _l10n.speechFor('close_thumb');
    }
  }

  Future<void> _runAiCommand(String text) async {
    setState(() {
      _aiFeedback = 'Texto ouvido: "$text"\nA interpretar o comando...';
    });

    final action = LocalCommandAiService.classify(text);

    if (action == 'unknown') {
      setState(() {
        _aiFeedback = 'Não consegui entender: "$text"';
      });

      await _speakFast(_l10n.didNotUnderstand);
      return;
    }

    final command = _commandFromAction(action);

    if (command == null) {
      setState(() {
        _aiFeedback = 'Comando inválido: $action';
      });
      return;
    }

    final spoken = _commandToSpeech(command);

    setState(() {
      _aiFeedback =
          'Texto ouvido: "$text"\nComando identificado: $action\nResposta: $spoken';
    });

    await _speakFast(spoken);
    await _executeCommand(command);
  }

  Future<String> _bestSpeechLocale() async {
    final preferred = appSettings.language == AppLanguage.portuguese
        ? 'pt_BR'
        : 'en_US';
    try {
      final locales = await _speech.locales();
      final exact = locales.where(
        (locale) => locale.localeId.toLowerCase() == preferred.toLowerCase(),
      );
      if (exact.isNotEmpty) return exact.first.localeId;

      final prefix = appSettings.language == AppLanguage.portuguese
          ? 'pt'
          : 'en';
      final sameLanguage = locales.where(
        (locale) => locale.localeId.toLowerCase().startsWith(prefix),
      );
      if (sameLanguage.isNotEmpty) return sameLanguage.first.localeId;
    } catch (_) {
      // If locale loading fails, try the preferred locale anyway.
    }
    return preferred;
  }

  Future<void> _listenVoiceCommand() async {
    if (_listening) {
      await _speech.stop();
      setState(() => _listening = false);
      return;
    }

    try {
      await _speech.cancel();
    } catch (_) {}
    _speech = stt.SpeechToText();

    final available = await _speech.initialize(
      onStatus: (status) {
        if ((status == 'done' || status == 'notListening') && mounted) {
          setState(() => _listening = false);
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _listening = false;
            _aiFeedback = _speechErrorMessage(error.errorMsg);
          });
        }
      },
    );

    if (!available) {
      setState(() => _aiFeedback = _l10n.micUnavailable);
      return;
    }

    final localeId = await _bestSpeechLocale();

    setState(() {
      _listening = true;
      _lastVoiceText = '';
      _aiFeedback = '${_l10n.listening} ($localeId)';
    });

    try {
      await _speech.listen(
        localeId: localeId,
        onResult: (result) async {
          final words = result.recognizedWords;
          setState(() => _lastVoiceText = words);

          if (result.finalResult && words.trim().isNotEmpty) {
            await _speech.stop();
            if (mounted) setState(() => _listening = false);
            await _runAiCommand(words);
          }
        },
        listenFor: const Duration(seconds: 8),
        pauseFor: const Duration(seconds: 2),
        listenOptions: stt.SpeechListenOptions(
          onDevice: false,
          cancelOnError: true,
          partialResults: false,
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _listening = false;
          _aiFeedback = _speechErrorMessage(e.toString());
        });
      }
    }
  }

  String _speechErrorMessage(String error) {
    final lower = error.toLowerCase();
    if (lower.contains('server') || lower.contains('disconnected')) {
      return _l10n.speechServerDisconnectedError;
    }
    if (lower.contains('network')) {
      return _l10n.speechNetworkError;
    }
    if (lower.contains('language') ||
        lower.contains('locale') ||
        lower.contains('not supported')) {
      return _l10n.speechLanguageError;
    }
    return _l10n.micError(error);
  }

  void _openCommandHelp() {
    final l10n = _l10n;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.commandsHelp,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(l10n.commandsHelpIntro),
              const SizedBox(height: 12),
              ...l10n.commandHelpItems.map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text('• $item'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appSettings,
      builder: (context, _) {
        final l10n = _l10n;
        return ValueListenableBuilder<bool>(
          valueListenable: Esp32WifiService.instance.isConnected,
          builder: (context, connected, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    connected ? l10n.connected : l10n.disconnected,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _loading ? null : _connect,
                      icon: Icon(connected ? Icons.wifi : Icons.wifi_off),
                      label: Text(
                        _loading ? l10n.connecting : l10n.connectArmiac,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: connected ? _listenVoiceCommand : null,
                      icon: Icon(_listening ? Icons.stop : Icons.mic),
                      label: Text(
                        _listening ? l10n.stopVoice : l10n.voiceControl,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      TextButton.icon(
                        onPressed: _openTutorial,
                        icon: const Icon(Icons.slideshow_outlined),
                        label: Text(l10n.tutorial),
                      ),
                      TextButton.icon(
                        onPressed: _openCommandHelp,
                        icon: const Icon(Icons.help_outline),
                        label: Text(l10n.help),
                      ),
                    ],
                  ),
                  if (_lastVoiceText.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      '${l10n.voice}: $_lastVoiceText',
                      textAlign: TextAlign.center,
                    ),
                  ],
                  if (_aiFeedback.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(_aiFeedback, textAlign: TextAlign.center),
                  ],
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      l10n.quickCommands,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: [
                      ActionChip(
                        label: Text(l10n.openCloseHand),
                        onPressed: connected && !_demoRunning ? _toggleHand : null,
                      ),
                      ActionChip(
                        label: Text(l10n.peace),
                        onPressed: connected
                            && !_demoRunning
                            ? () => _runGesture('peace')
                            : null,
                      ),
                      ActionChip(
                        label: Text(l10n.numberTwo),
                        onPressed: connected
                            && !_demoRunning
                            ? () => _runGesture('two')
                            : null,
                      ),
                      ActionChip(
                        label: Text(l10n.point),
                        onPressed: connected
                            && !_demoRunning
                            ? () => _runGesture('point')
                            : null,
                      ),
                      ActionChip(
                        label: Text(l10n.numberFour),
                        onPressed: connected && !_demoRunning
                            ? () => _runGesture('four')
                            : null,
                      ),
                      ActionChip(
                        label: Text(l10n.thumbsUp),
                        onPressed: connected && !_demoRunning
                            ? () => _runGesture('thumbs_up')
                            : null,
                      ),
                      ActionChip(
                        label: const Text('OK'),
                        onPressed: connected && !_demoRunning ? () => _runGesture('ok') : null,
                      ),
                      ActionChip(
                        label: Text(l10n.wave),
                        onPressed: connected && !_demoRunning ? () => _runGesture('wave') : null,
                      ),
                      ActionChip(
                        label: Text(l10n.palmUpShort),
                        onPressed: connected
                            && !_demoRunning
                            ? () => _runGesture('palm_up')
                            : null,
                      ),
                      ActionChip(
                        label: Text(l10n.palmDownShort),
                        onPressed: connected
                            && !_demoRunning
                            ? () => _runGesture('palm_down')
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: connected
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ControlPage(),
                                ),
                              );
                            }
                          : null,
                      child: Text(l10n.manualControl),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
