/// Detects language associated with a mental-health crisis in a message, so
/// the chat UI can surface support resources - to either the person who
/// wrote it, or the listener reading it.
///
/// This is a non-clinical starting point: a short, plain-English keyword
/// list, not a reviewed or validated screening tool. It needs real clinical
/// input before this app is used in production.
class CrisisDetector {
  const CrisisDetector._();

  static const keywords = [
    'kill myself',
    'end my life',
    'want to die',
    'better off dead',
    'no reason to live',
    'not worth living',
    'suicide',
    'suicidal',
    'hurt myself',
    'hurting myself',
    'self-harm',
    'self harm',
    "can't go on",
  ];

  /// Word-boundary matching (not a raw substring check) so phrases like
  /// "dead tired" or "killing time" don't false-positive.
  static bool containsCrisisSignal(String text) {
    return keywords.any(
      (keyword) => RegExp(r'\b' + RegExp.escape(keyword) + r'\b', caseSensitive: false).hasMatch(text),
    );
  }
}
