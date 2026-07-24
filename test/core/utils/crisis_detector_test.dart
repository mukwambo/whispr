import 'package:flutter_test/flutter_test.dart';
import 'package:whispr/core/utils/crisis_detector.dart';

void main() {
  group('CrisisDetector.containsCrisisSignal', () {
    for (final keyword in CrisisDetector.keywords) {
      test('detects "$keyword" in context', () {
        expect(CrisisDetector.containsCrisisSignal('Sometimes I feel like I $keyword honestly'), isTrue);
      });
    }

    test('is case-insensitive', () {
      expect(CrisisDetector.containsCrisisSignal('I WANT TO DIE'), isTrue);
    });

    test('does not flag ordinary messages', () {
      expect(CrisisDetector.containsCrisisSignal('Hey, how has your day been?'), isFalse);
    });

    test('does not false-positive on unrelated phrases sharing a word', () {
      expect(CrisisDetector.containsCrisisSignal("I'm dead tired after today"), isFalse);
      expect(CrisisDetector.containsCrisisSignal('We were killing time before the movie'), isFalse);
    });
  });
}
