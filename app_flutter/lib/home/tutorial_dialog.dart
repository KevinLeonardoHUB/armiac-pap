import 'package:flutter/material.dart';

import '../app_language.dart';
import '../l10n.dart';

class TutorialDialog extends StatefulWidget {
  const TutorialDialog({super.key});

  @override
  State<TutorialDialog> createState() => _TutorialDialogState();
}

class _TutorialDialogState extends State<TutorialDialog> {
  final PageController _controller = PageController();
  int _page = 0;

  L10n get _l10n => L10n(appSettings.language);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _goTo(int page) async {
    await _controller.animateToPage(
      page,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = _l10n;
    final pages = [
      _TutorialCard(
        icon: Icons.power,
        title: l10n.tutorialStep1Title,
        body: l10n.tutorialStep1Body,
      ),
      _TutorialCard(
        icon: Icons.wifi,
        title: l10n.tutorialStep2Title,
        body: l10n.tutorialStep2Body,
        imageAsset: 'assets/tutorial/armiac_wifi.png',
      ),
    ];

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 380,
          maxHeight: MediaQuery.of(context).size.height * 0.88,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.tutorialTitle,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 335,
                child: PageView.builder(
                  controller: _controller,
                  itemCount: pages.length,
                  onPageChanged: (value) => setState(() => _page = value),
                  itemBuilder: (context, index) => pages[index],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _page == index ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _page == index
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  if (_page > 0)
                    TextButton(
                      onPressed: () => _goTo(_page - 1),
                      child: Text(l10n.previous),
                    )
                  else
                    const SizedBox.shrink(),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _page == pages.length - 1
                        ? () => Navigator.of(context).pop()
                        : () => _goTo(_page + 1),
                    child: Text(
                      _page == pages.length - 1 ? l10n.finish : l10n.next,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TutorialCard extends StatelessWidget {
  const _TutorialCard({
    required this.icon,
    required this.title,
    required this.body,
    this.imageAsset,
  });

  final IconData icon;
  final String title;
  final String body;
  final String? imageAsset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageAsset != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  height: 175,
                  color: Colors.white,
                  child: Image.asset(
                    imageAsset!,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ] else ...[
              CircleAvatar(
                radius: 38,
                child: Icon(icon, size: 38),
              ),
              const SizedBox(height: 22),
            ],
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              body,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, height: 1.3),
            ),
          ],
        ),
      ),
    );
  }
}
