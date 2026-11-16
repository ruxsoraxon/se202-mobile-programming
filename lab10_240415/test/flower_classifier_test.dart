import 'package:flutter_test/flutter_test.dart';
import 'package:lab10_240415/services/flower_classifier.dart';

void main() {
  group('parseLabels', () {
    test('parses Teachable Machine numbered labels in order', () {
      expect(
        parseLabels('0 rose\n1 sunflower\n2 tulip'),
        ['rose', 'sunflower', 'tulip'],
      );
    });

    test('handles CRLF, blank lines, and labels containing spaces', () {
      expect(
        parseLabels('0 blackberry lily\r\n\r\n1 tiger lily\r\n'),
        ['blackberry lily', 'tiger lily'],
      );
    });
  });
}
