import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../services/esp32_wifi_service.dart';
import 'control_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum _ArmiacCommand {
  reset,
  toggleHand,
  togglePeace,
  toggleIndex,
  toggleMiddle,
  toggleRingPinky,
  toggleThumb,
}

class _HomePageState extends State<HomePage> {
  bool _loading = false;
  bool _listening = false;
  String _lastVoiceText = '';
  String _aiFeedback = '';

  final stt.SpeechToText _speech = stt.SpeechToText();

  bool handClosed = false;
  bool peaceMode = false;
  bool indexClosed = false;
  bool middleClosed = false;
  bool ringPinkyClosed = false;
  bool thumbClosed = false;

  Future<void> _connect() async {
    setState(() => _loading = true);

    try {
      await Esp32WifiService.instance.connect();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conectado ao ARMIAC')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _send(String action) async {
    if (!Esp32WifiService.instance.isConnected.value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conecte ao Wi-Fi do ARMIAC primeiro.')),
      );
      return;
    }

    try {
      await Esp32WifiService.instance.action(action);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: $e')),
      );
    }
  }

  Future<void> _resetAll() async {
    await _send('open_hand');
    setState(() {
      handClosed = false;
      peaceMode = false;
      indexClosed = false;
      middleClosed = false;
      ringPinkyClosed = false;
      thumbClosed = false;
    });
  }

  Future<void> _toggleHand() async {
    await _send(handClosed ? 'open_hand' : 'close_hand');
    setState(() {
      handClosed = !handClosed;
      if (handClosed) {
        peaceMode = false;
        indexClosed = true;
        middleClosed = true;
        ringPinkyClosed = true;
        thumbClosed = true;
      } else {
        indexClosed = false;
        middleClosed = false;
        ringPinkyClosed = false;
        thumbClosed = false;
      }
    });
  }

  Future<void> _togglePeace() async {
    await _send(peaceMode ? 'open_hand' : 'peace');
    setState(() {
      peaceMode = !peaceMode;
      if (peaceMode) {
        handClosed = false;
        indexClosed = false;
        middleClosed = false;
        ringPinkyClosed = true;
        thumbClosed = true;
      } else {
        ringPinkyClosed = false;
        thumbClosed = false;
      }
    });
  }

  Future<void> _toggleIndex() async {
    await _send(indexClosed ? 'open_index' : 'close_index');
    setState(() {
      indexClosed = !indexClosed;
      handClosed = false;
      peaceMode = false;
    });
  }

  Future<void> _toggleMiddle() async {
    await _send(middleClosed ? 'open_middle' : 'close_middle');
    setState(() {
      middleClosed = !middleClosed;
      handClosed = false;
      peaceMode = false;
    });
  }

  Future<void> _toggleRingPinky() async {
    await _send(ringPinkyClosed ? 'open_ringpinky' : 'close_ringpinky');
    setState(() {
      ringPinkyClosed = !ringPinkyClosed;
      handClosed = false;
      peaceMode = false;
    });
  }

  Future<void> _toggleThumb() async {
    await _send(thumbClosed ? 'open_thumb' : 'close_thumb');
    setState(() {
      thumbClosed = !thumbClosed;
      handClosed = false;
      peaceMode = false;
    });
  }

  Future<void> _executeCommand(_ArmiacCommand command) async {
    switch (command) {
      case _ArmiacCommand.reset:
        await _resetAll();
        break;
      case _ArmiacCommand.toggleHand:
        await _toggleHand();
        break;
      case _ArmiacCommand.togglePeace:
        await _togglePeace();
        break;
      case _ArmiacCommand.toggleIndex:
        await _toggleIndex();
        break;
      case _ArmiacCommand.toggleMiddle:
        await _toggleMiddle();
        break;
      case _ArmiacCommand.toggleRingPinky:
        await _toggleRingPinky();
        break;
      case _ArmiacCommand.toggleThumb:
        await _toggleThumb();
        break;
    }
  }

  String _normalize(String text) {
    return text
        .toLowerCase()
        .replaceAll('ã', 'a')
        .replaceAll('á', 'a')
        .replaceAll('à', 'a')
        .replaceAll('â', 'a')
        .replaceAll('é', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ô', 'o')
        .replaceAll('õ', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ç', 'c');
  }

  _ArmiacCommand? _understandCommand(String text) {
    final command = _normalize(text);

    if (command.contains('reset') ||
        command.contains('abrir mao') ||
        command.contains('abre a mao') ||
        command.contains('abrir tudo')) {
      return _ArmiacCommand.reset;
    }
    if (command.contains('paz') || command.contains('vitoria')) {
      return _ArmiacCommand.togglePeace;
    }
    if (command.contains('indicador')) return _ArmiacCommand.toggleIndex;
    if (command.contains('medio')) return _ArmiacCommand.toggleMiddle;
    if (command.contains('anelar') || command.contains('mindinho')) {
      return _ArmiacCommand.toggleRingPinky;
    }
    if (command.contains('dedao') ||
        command.contains('polegar') ||
        command.contains('dedo grande')) {
      return _ArmiacCommand.toggleThumb;
    }
    if (command.contains('mao') || command.contains('punho')) {
      return _ArmiacCommand.toggleHand;
    }

    return null;
  }

  Future<void> _runAiCommand(String text) async {
    final command = _understandCommand(text);
    if (command == null) {
      setState(() {
        _aiFeedback = 'Não entendi. Ex.: "fechar mão", "símbolo paz", "dedão", "resetar".';
      });
      return;
    }

    setState(() => _aiFeedback = 'Comando entendido: $text');
    await _executeCommand(command);
  }

  Future<void> _listenVoiceCommand() async {
    if (_listening) {
      await _speech.stop();
      setState(() => _listening = false);
      return;
    }

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
            _aiFeedback = 'Erro no microfone: ${error.errorMsg}';
          });
        }
      },
    );

    if (!available) {
      setState(() => _aiFeedback = 'Microfone indisponível ou sem permissão.');
      return;
    }

    setState(() {
      _listening = true;
      _lastVoiceText = '';
      _aiFeedback = 'Estou a ouvir...';
    });

    await _speech.listen(
      localeId: 'pt_PT',
      listenFor: const Duration(seconds: 8),
      pauseFor: const Duration(seconds: 2),
      onResult: (result) async {
        final words = result.recognizedWords;
        setState(() => _lastVoiceText = words);
        if (result.finalResult && words.trim().isNotEmpty) {
          await _speech.stop();
          if (mounted) setState(() => _listening = false);
          await _runAiCommand(words);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: Esp32WifiService.instance.isConnected,
      builder: (context, connected, _) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                connected ? 'ARMIAC Conectado' : 'ARMIAC Desconectado',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _connect,
                  icon: Icon(connected ? Icons.wifi : Icons.wifi_off),
                  label: Text(_loading ? 'Conectando...' : 'Conectar ao ARMIAC'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: connected ? _listenVoiceCommand : null,
                  icon: Icon(_listening ? Icons.stop : Icons.mic),
                  label: Text(_listening ? 'Parar voz com IA' : 'Controlo por voz com IA'),
                ),
              ),
              if (_lastVoiceText.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('Voz: $_lastVoiceText', textAlign: TextAlign.center),
              ],
              if (_aiFeedback.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(_aiFeedback, textAlign: TextAlign.center),
              ],
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ControlPage()),
                    );
                  },
                  child: const Text('Controle'),
                ),
              ),
              const SizedBox(height: 25),
              if (!connected)
                const Text(
                  'Conecte o celular no Wi-Fi do ARMIAC (ARMIAC_ESP32)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
            ],
          ),
        );
      },
    );
  }
}
