import 'package:flutter/material.dart';
import '../services/esp32_wifi_service.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});
  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  bool handClosed = false, peaceMode = false, indexClosed = false, middleClosed = false, ringPinkyClosed = false, thumbClosed = false;

  Future<void> _send(String action) async {
    if (!Esp32WifiService.instance.isConnected.value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Conecte ao Wi-Fi do ARMIAC primeiro.')));
      return;
    }
    try {
      await Esp32WifiService.instance.action(action);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
    }
  }

  Future<void> _resetAll() async {
    await _send('open_hand');
    setState(() { handClosed = false; peaceMode = false; indexClosed = false; middleClosed = false; ringPinkyClosed = false; thumbClosed = false; });
  }

  Future<void> _toggleHand() async {
    await _send(handClosed ? 'open_hand' : 'close_hand');
    setState(() {
      handClosed = !handClosed;
      if (handClosed) { peaceMode = false; indexClosed = true; middleClosed = true; ringPinkyClosed = true; thumbClosed = true; }
      else { indexClosed = false; middleClosed = false; ringPinkyClosed = false; thumbClosed = false; }
    });
  }

  Future<void> _togglePeace() async {
    await _send(peaceMode ? 'open_hand' : 'peace');
    setState(() {
      peaceMode = !peaceMode;
      if (peaceMode) { handClosed = false; indexClosed = false; middleClosed = false; ringPinkyClosed = true; thumbClosed = true; }
      else { ringPinkyClosed = false; thumbClosed = false; }
    });
  }

  Future<void> _toggleIndex() async { await _send(indexClosed ? 'open_index' : 'close_index'); setState(() { indexClosed = !indexClosed; handClosed = false; peaceMode = false; }); }
  Future<void> _toggleMiddle() async { await _send(middleClosed ? 'open_middle' : 'close_middle'); setState(() { middleClosed = !middleClosed; handClosed = false; peaceMode = false; }); }
  Future<void> _toggleRingPinky() async { await _send(ringPinkyClosed ? 'open_ringpinky' : 'close_ringpinky'); setState(() { ringPinkyClosed = !ringPinkyClosed; handClosed = false; peaceMode = false; }); }
  Future<void> _toggleThumb() async { await _send(thumbClosed ? 'open_thumb' : 'close_thumb'); setState(() { thumbClosed = !thumbClosed; handClosed = false; peaceMode = false; }); }

  Widget _toggleButton({required String label, required bool state, required VoidCallback onPressed}) {
    return SizedBox(width: double.infinity, child: ElevatedButton(onPressed: onPressed, style: ElevatedButton.styleFrom(backgroundColor: state ? Colors.green : null), child: Text(state ? '$label ✅' : label)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Controle da Mão')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          ValueListenableBuilder<bool>(
            valueListenable: Esp32WifiService.instance.isConnected,
            builder: (context, connected, _) => Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(border: Border.all(color: connected ? Colors.green : Colors.red), borderRadius: BorderRadius.circular(12)),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(connected ? Icons.wifi : Icons.wifi_off),
                const SizedBox(width: 8),
                Text(connected ? 'Ligado ao ARMIAC' : 'Não ligado ao ARMIAC', style: const TextStyle(fontWeight: FontWeight.bold)),
              ]),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _resetAll, style: ElevatedButton.styleFrom(backgroundColor: Colors.red), child: const Text('RESETAR (Abrir mão)'))),
          const SizedBox(height: 20),
          _toggleButton(label: 'Fechar mão', state: handClosed, onPressed: _toggleHand),
          const SizedBox(height: 10),
          _toggleButton(label: 'Símbolo paz', state: peaceMode, onPressed: _togglePeace),
          const SizedBox(height: 10),
          _toggleButton(label: 'Dedo indicador', state: indexClosed, onPressed: _toggleIndex),
          const SizedBox(height: 10),
          _toggleButton(label: 'Dedo médio', state: middleClosed, onPressed: _toggleMiddle),
          const SizedBox(height: 10),
          _toggleButton(label: 'Dedo anelar + mindinho', state: ringPinkyClosed, onPressed: _toggleRingPinky),
          const SizedBox(height: 10),
          _toggleButton(label: 'Dedão', state: thumbClosed, onPressed: _toggleThumb),
        ]),
      ),
    );
  }
}
