import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Widget yang menggambar garis penuntun horizontal (Mushaf Bergaris Standar Indonesia)
/// secara dinamis dan presisi tepat di bawah setiap baris ayat, sehingga tidak akan
/// pernah bergeser, miring, ataupun menabrak huruf Arab meskipun font size diubah.
class MushafRuledText extends SingleChildRenderObjectWidget {
  final Color? lineColor;
  final double strokeWidth;
  final bool showLines;

  const MushafRuledText({
    super.key,
    required Widget child,
    this.lineColor,
    this.strokeWidth = 0.8,
    this.showLines = true,
  }) : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveColor = lineColor ?? (isDark ? const Color(0xFF223832) : const Color(0xFFE6DDC8));
    return RenderMushafRuledText(
      lineColor: effectiveColor,
      strokeWidth: strokeWidth,
      showLines: showLines,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderMushafRuledText renderObject) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveColor = lineColor ?? (isDark ? const Color(0xFF223832) : const Color(0xFFE6DDC8));
    renderObject
      ..lineColor = effectiveColor
      ..strokeWidth = strokeWidth
      ..showLines = showLines;
  }
}

class RenderMushafRuledText extends RenderProxyBox {
  Color lineColor;
  double strokeWidth;
  bool showLines;

  RenderMushafRuledText({
    required this.lineColor,
    required this.strokeWidth,
    required this.showLines,
  });

  @override
  void paint(PaintingContext context, Offset offset) {
    final paragraph = child;
    if (showLines && paragraph is RenderParagraph) {
      final paint = Paint()
        ..color = lineColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke;

      final textLength = paragraph.text.toPlainText().length;
      if (textLength > 0) {
        final boxes = paragraph.getBoxesForSelection(
          TextSelection(baseOffset: 0, extentOffset: textLength),
        );

        // Kelompokkan koordinat bottom per baris untuk menghindari garis ganda.
        // Pada baris yang memiliki medali ayat (WidgetSpan), koordinat bottom
        // medali dan huruf teks Arab dapat berselisih 5-12px.
        // Dengan ambang 20px, seluruh elemen pada baris yang sama akan menyatu
        // menjadi 1 garis tunggal di posisi terbawah (membersihkan medali & teks).
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
        for (final b in lines) {
          final y = offset.dy + b;
          context.canvas.drawLine(
            Offset(offset.dx + 4, y),
            Offset(offset.dx + size.width - 4, y),
            paint,
          );
        }
      }
    }

    // Gambar teks Al-Qur'an di atas canvas
    super.paint(context, offset);
  }
}
