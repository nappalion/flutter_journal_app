import 'package:flutter/material.dart';

import 'auth_layout.dart';

class ProfileEmoji {
  static const field = 'emoji';
  static const fallback = '🌸';
  static const choices = [
    '🌸', '🌻', '🌿', '🍀', '🌙', '⭐️', '☀️', '🌈',
    '🍓', '🍑', '🍵', '☕️', '📚', '✏️', '🎧', '🎨',
    '🐱', '🐶', '🐻', '🐰', '🦊', '🐸', '🐢', '🦋',
  ];
}

/// Shows a sheet of [ProfileEmoji.choices] and returns the one tapped, or null
/// if the sheet was dismissed.
Future<String?> showEmojiPicker(BuildContext context, {String? selected}) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: AuthColors.paper,
    showDragHandle: true,
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Pick your emoji",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AuthColors.ink,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 6,
                shrinkWrap: true,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (final emoji in ProfileEmoji.choices)
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => Navigator.pop(context, emoji),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: emoji == selected
                                ? AuthColors.sage
                                : const Color(0xFFE6E1D6),
                            width: emoji == selected ? 1.5 : 1,
                          ),
                        ),
                        child: Text(emoji, style: const TextStyle(fontSize: 26)),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// A form row styled like the auth text fields that shows the chosen emoji
/// and opens [showEmojiPicker] when tapped.
class EmojiField extends StatelessWidget {
  final String emoji;
  final ValueChanged<String> onChanged;
  final bool enabled;

  const EmojiField({
    super.key,
    required this.emoji,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: enabled
          ? () async {
              FocusScope.of(context).unfocus();
              final picked = await showEmojiPicker(context, selected: emoji);
              if (picked != null) onChanged(picked);
            }
          : null,
      child: InputDecorator(
        decoration: authInputDecoration(
          label: "Profile emoji",
          icon: Icons.mood_outlined,
          suffixIcon: const Icon(Icons.chevron_right, color: AuthColors.muted),
        ),
        child: Text(emoji, style: const TextStyle(fontSize: 22, height: 1)),
      ),
    );
  }
}
