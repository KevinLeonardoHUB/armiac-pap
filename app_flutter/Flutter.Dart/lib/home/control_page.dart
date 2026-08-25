import 'package:flutter/material.dart';

import '../app_language.dart';
import '../l10n.dart';
import '../services/esp32_wifi_service.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({super.key});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  bool handClosed = false;
  bool peaceMode = false;
  bool indexClosed = false;
  bool middleClosed = false;
  bool ringPinkyClosed = false;
  bool thumbClosed = false;
  String lastGestureKey = 'open_hand';
  String forearmKey = 'forearm_neutral';
  bool _demoRunning = false;

  L10n get _l10n => L10n(appSettings.language);

  String _gestureLabel(String key) {
    final l10n = _l10n;
    switch (key) {
      case 'open_hand':
        return l10n.openHandState;
      case 'close_hand':
        return l10n.closedFistState;
      case 'peace':
        return l10n.peaceSign;
      case 'two':
        return l10n.numberTwo;
      case 'point':
        return l10n.point;
      case 'three':
        return l10n.numberThree;
      case 'four':
        return l10n.numberFour;
      case 'thumbs_up':
        return l10n.thumbsUp;
      case 'ok':
        return l10n.okSign;
      case 'wave':
        return l10n.wave;
      case 'demo':
        return l10n.demoState;
      case 'index_closed':
        return l10n.indexClosed;
      case 'index_open':
        return l10n.indexOpen;
      case 'middle_closed':
        return l10n.middleClosed;
      case 'middle_open':
        return l10n.middleOpen;
      case 'ring_pinky_closed':
        return l10n.ringPinkyClosed;
      case 'ring_pinky_open':
        return l10n.ringPinkyOpen;
      case 'thumb_closed':
        return l10n.thumbClosed;
      case 'thumb_open':
        return l10n.thumbOpen;
    }
    return key;
  }

  String _forearmLabel(String key) {
    final l10n = _l10n;
    switch (key) {
      case 'palm_up':
        return l10n.palmUpState;
      case 'palm_down':
        return l10n.palmDownState;
      default:
        return l10n.forearmCenterState;
    }
  }

  Future<bool> _send(String action) async {
    if (!Esp32WifiService.instance.isConnected.value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_l10n.connectFirst)));
      return false;
    }

    try {
      await Esp32WifiService.instance.action(action);
      return true;
    } catch (e) {
      if (!mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_l10n.actionFailed)));
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
    lastGestureKey = 'open_hand';
  }

  void _setClosedHand() {
    handClosed = true;
    peaceMode = false;
    indexClosed = true;
    middleClosed = true;
    ringPinkyClosed = true;
    thumbClosed = true;
    lastGestureKey = 'close_hand';
  }

  void _applyActionState(String action) {
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
        lastGestureKey = 'peace';
        break;
      case 'two':
        handClosed = false;
        peaceMode = false;
        indexClosed = false;
        middleClosed = false;
        ringPinkyClosed = true;
        thumbClosed = true;
        lastGestureKey = 'two';
        break;
      case 'point':
        handClosed = false;
        peaceMode = false;
        indexClosed = false;
        middleClosed = true;
        ringPinkyClosed = true;
        thumbClosed = true;
        lastGestureKey = 'point';
        break;
      case 'three':
        handClosed = false;
        peaceMode = false;
        indexClosed = false;
        middleClosed = false;
        ringPinkyClosed = true;
        thumbClosed = false;
        lastGestureKey = 'three';
        break;
      case 'four':
        handClosed = false;
        peaceMode = false;
        indexClosed = false;
        middleClosed = false;
        ringPinkyClosed = false;
        thumbClosed = true;
        lastGestureKey = 'four';
        break;
      case 'thumbs_up':
        handClosed = false;
        peaceMode = false;
        indexClosed = true;
        middleClosed = true;
        ringPinkyClosed = true;
        thumbClosed = false;
        lastGestureKey = 'thumbs_up';
        break;
      case 'ok':
        handClosed = false;
        peaceMode = false;
        indexClosed = true;
        middleClosed = false;
        ringPinkyClosed = false;
        thumbClosed = false;
        lastGestureKey = 'ok';
        break;
      case 'wave':
        handClosed = false;
        peaceMode = false;
        indexClosed = false;
        middleClosed = false;
        ringPinkyClosed = false;
        thumbClosed = false;
        lastGestureKey = 'wave';
        break;
      case 'palm_up':
      case 'palm_down':
      case 'forearm_neutral':
        forearmKey = action;
        break;
      case 'demo':
        lastGestureKey = 'demo';
        break;
    }
  }

  Future<bool> _sendActionAndUpdate(String action) async {
    final ok = await _send(action);
    if (!ok || !mounted) return false;
    setState(() => _applyActionState(action));
    return true;
  }

  Future<void> _gesture(String action) async {
    if (_demoRunning) return;

    if (action == 'demo') {
      await _runDemo();
      return;
    }

    if (action == 'wave') {
      final opened = await _sendActionAndUpdate('open_hand');
      if (!opened) return;
      await Future<void>.delayed(const Duration(milliseconds: 180));
      await _sendActionAndUpdate('wave');
      return;
    }

    final sent = await _sendActionAndUpdate(action);
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
      // Acenar sempre começa com a mão aberta.
      'open_hand',
      'wave',
      'forearm_neutral',
      'open_hand',
    ];

    for (final action in sequence) {
      if (!mounted) return;
      final ok = await _sendActionAndUpdate(action);
      if (!ok) break;
      await Future<void>.delayed(const Duration(milliseconds: 450));
    }

    if (mounted) {
      setState(() {
        _demoRunning = false;
        lastGestureKey = 'demo';
      });
    }
  }

  Future<void> _toggleHand() async {
    await _gesture(handClosed ? 'open_hand' : 'close_hand');
  }

  Future<void> _toggleIndex() async {
    final ok = await _send(indexClosed ? 'open_index' : 'close_index');
    if (!ok || !mounted) return;
    setState(() {
      indexClosed = !indexClosed;
      handClosed = false;
      peaceMode = false;
      lastGestureKey = indexClosed ? 'index_closed' : 'index_open';
    });

    if (forearmKey != 'forearm_neutral') {
      await Future<void>.delayed(const Duration(milliseconds: 120));
      await _send(forearmKey);
    }
  }

  Future<void> _toggleMiddle() async {
    final ok = await _send(middleClosed ? 'open_middle' : 'close_middle');
    if (!ok || !mounted) return;
    setState(() {
      middleClosed = !middleClosed;
      handClosed = false;
      peaceMode = false;
      lastGestureKey = middleClosed ? 'middle_closed' : 'middle_open';
    });

    if (forearmKey != 'forearm_neutral') {
      await Future<void>.delayed(const Duration(milliseconds: 120));
      await _send(forearmKey);
    }
  }

  Future<void> _toggleRingPinky() async {
    final ok = await _send(ringPinkyClosed ? 'open_ringpinky' : 'close_ringpinky');
    if (!ok || !mounted) return;
    setState(() {
      ringPinkyClosed = !ringPinkyClosed;
      handClosed = false;
      peaceMode = false;
      lastGestureKey = ringPinkyClosed ? 'ring_pinky_closed' : 'ring_pinky_open';
    });

    if (forearmKey != 'forearm_neutral') {
      await Future<void>.delayed(const Duration(milliseconds: 120));
      await _send(forearmKey);
    }
  }

  Future<void> _toggleThumb() async {
    final ok = await _send(thumbClosed ? 'open_thumb' : 'close_thumb');
    if (!ok || !mounted) return;
    setState(() {
      thumbClosed = !thumbClosed;
      handClosed = false;
      peaceMode = false;
      lastGestureKey = thumbClosed ? 'thumb_closed' : 'thumb_open';
    });

    if (forearmKey != 'forearm_neutral') {
      await Future<void>.delayed(const Duration(milliseconds: 120));
      await _send(forearmKey);
    }
  }

  Widget _actionButton({required String label, required IconData icon, required VoidCallback? onPressed, Color? color}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        style: ElevatedButton.styleFrom(backgroundColor: color),
        label: Text(label),
      ),
    );
  }

  Widget _toggleButton({required String label, required bool state, required VoidCallback? onPressed}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: state ? Colors.green : null),
        child: Text(state ? '$label ✅' : label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appSettings,
      builder: (context, _) {
        final l10n = _l10n;
        return Scaffold(
          appBar: AppBar(title: Text(l10n.handControl)),
          body: ValueListenableBuilder<bool>(
            valueListenable: Esp32WifiService.instance.isConnected,
            builder: (context, connected, _) => SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: connected ? Colors.green : Colors.red),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(connected ? Icons.wifi : Icons.wifi_off),
                        const SizedBox(width: 8),
                        Text(
                          connected ? l10n.connectedToArmiac : l10n.notConnectedToArmiac,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('${l10n.status}: ${_gestureLabel(lastGestureKey)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('${l10n.forearm}: ${_forearmLabel(forearmKey)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 14),
                  _actionButton(label: l10n.openCloseHand, icon: Icons.pan_tool_alt, onPressed: connected && !_demoRunning ? _toggleHand : null),
                  const SizedBox(height: 10),
                  _actionButton(label: l10n.peaceSign, icon: Icons.gesture, onPressed: connected && !_demoRunning ? () => _gesture('peace') : null),
                  const SizedBox(height: 10),
                  _actionButton(label: l10n.numberTwo, icon: Icons.looks_two, onPressed: connected && !_demoRunning ? () => _gesture('two') : null),
                  const SizedBox(height: 10),
                  _actionButton(label: l10n.point, icon: Icons.touch_app, onPressed: connected && !_demoRunning ? () => _gesture('point') : null),
                  const SizedBox(height: 10),
                  _actionButton(label: l10n.numberThree, icon: Icons.looks_3, onPressed: connected && !_demoRunning ? () => _gesture('three') : null),
                  const SizedBox(height: 10),
                  _actionButton(label: l10n.numberFour, icon: Icons.looks_4, onPressed: connected && !_demoRunning ? () => _gesture('four') : null),
                  const SizedBox(height: 10),
                  _actionButton(label: l10n.thumbsUp, icon: Icons.thumb_up, onPressed: connected && !_demoRunning ? () => _gesture('thumbs_up') : null),
                  const SizedBox(height: 10),
                  _actionButton(label: l10n.okSign, icon: Icons.check_circle_outline, onPressed: connected && !_demoRunning ? () => _gesture('ok') : null),
                  const SizedBox(height: 10),
                  _actionButton(label: l10n.wave, icon: Icons.waving_hand, onPressed: connected && !_demoRunning ? () => _gesture('wave') : null),
                  const SizedBox(height: 10),
                  _actionButton(label: l10n.palmUp, icon: Icons.keyboard_arrow_up, onPressed: connected && !_demoRunning ? () => _gesture('palm_up') : null),
                  const SizedBox(height: 10),
                  _actionButton(label: l10n.palmDown, icon: Icons.keyboard_arrow_down, onPressed: connected && !_demoRunning ? () => _gesture('palm_down') : null),
                  const SizedBox(height: 10),
                  _actionButton(label: l10n.forearmNeutral, icon: Icons.swap_vert, onPressed: connected && !_demoRunning ? () => _gesture('forearm_neutral') : null),
                  const SizedBox(height: 10),
                  _actionButton(label: l10n.automaticDemo, icon: Icons.play_arrow, onPressed: connected && !_demoRunning ? () => _gesture('demo') : null),
                  const SizedBox(height: 20),
                  _toggleButton(label: l10n.indexFinger, state: indexClosed, onPressed: connected && !_demoRunning ? _toggleIndex : null),
                  const SizedBox(height: 10),
                  _toggleButton(label: l10n.middleFinger, state: middleClosed, onPressed: connected && !_demoRunning ? _toggleMiddle : null),
                  const SizedBox(height: 10),
                  _toggleButton(label: l10n.ringPinky, state: ringPinkyClosed, onPressed: connected && !_demoRunning ? _toggleRingPinky : null),
                  const SizedBox(height: 10),
                  _toggleButton(label: l10n.thumb, state: thumbClosed, onPressed: connected && !_demoRunning ? _toggleThumb : null),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
