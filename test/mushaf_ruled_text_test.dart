import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quranmu/components/mushaf_ruled_text.dart';

List<double> extractSingleLineBottoms(List<TextBox> boxes) {
  final sortedBoxes = List<TextBox>.from(boxes)
    ..sort((a, b) => a.top.compareTo(b.top));

  final lines = <double>[];
  for (final box in sortedBoxes) {
    final b = box.bottom;
    int matchedIndex = -1;
    for (int i = 0; i < lines.length; i++) {
      if ((lines[i] - b).abs() < 20.0) {
        matchedIndex = i;
        break;
      }
    }

    if (matchedIndex >= 0) {
      lines[matchedIndex] = math.max(lines[matchedIndex], b);
    } else {
      lines.add(b);
    }
  }
  lines.sort();
  return lines;
}

void main() {
  for (final fontSize in [18.0, 24.0, 36.0]) {
    testWidgets('Verify exactly one line per text line at fontSize $fontSize', (WidgetTester tester) async {
      final span = TextSpan(
        style: TextStyle(fontFamily: 'Amiri', fontSize: fontSize, height: 2.35),
        children: [
          const TextSpan(text: 'يس وَالْقُرْآنِ الْحَكِيمِ '),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.amber, width: 1.5),
              ),
              child: const Text('١', style: TextStyle(fontFamily: 'Amiri', fontSize: 13)),
            ),
          ),
          const TextSpan(text: ' إِنَّكَ لَمِنَ الْمُرْسَلِينَ عَلَىٰ صِرَاطٍ مُّسْتَقِيمٍ '),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.amber, width: 1.5),
              ),
              child: const Text('٢', style: TextStyle(fontFamily: 'Amiri', fontSize: 13)),
            ),
          ),
          const TextSpan(text: ' تَنزِيلَ الْعَزِيزِ الرَّحِيمِ'),
        ],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 320,
                child: RichText(
                  text: span,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ),
        ),
      );

      final RenderParagraph paragraph = tester.renderObject(find.byType(RichText).first);
      final boxes = paragraph.getBoxesForSelection(
        TextSelection(baseOffset: 0, extentOffset: span.toPlainText().length),
      );

      final lines = extractSingleLineBottoms(boxes);

      // Verify no two lines are within 25px of each other (no duplicate lines)
      for (int i = 1; i < lines.length; i++) {
        final step = lines[i] - lines[i - 1];
        expect(step, greaterThanOrEqualTo(25.0),
            reason: 'Lines $i and ${i - 1} are too close together! ($step px)');
      }
    });
  }

  testWidgets('MushafRuledText renders and paints correctly with child RichText', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: MushafRuledText(
              showLines: true,
              child: RichText(
                textDirection: TextDirection.rtl,
                text: const TextSpan(
                  text: 'بِسْمِ اللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
                  style: TextStyle(fontFamily: 'Amiri', fontSize: 24.0, height: 2.35),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(MushafRuledText), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
