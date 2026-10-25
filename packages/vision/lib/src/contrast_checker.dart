import 'dart:math' as math;

import 'color_namer.dart';

/// Which WCAG 2.x success criterion a contrast ratio was checked
/// against: AA is the project's stated minimum, AAA the stronger level
/// it aims for where feasible (see the organization's design system
/// notes).
enum WcagLevel {
  /// 4.5:1 for normal text, 3:1 for large text.
  aa,

  /// 7:1 for normal text, 4.5:1 for large text.
  aaa,
}

/// Result of checking the contrast between two colors.
class ContrastResult {
  /// Creates a result.
  const ContrastResult({required this.ratio, required this.largeText});

  /// The computed contrast ratio, from 1.0 (identical colors) to 21.0
  /// (black on white).
  final double ratio;

  /// Whether this result is being judged as large text (at least 18pt,
  /// or 14pt bold), which the WCAG thresholds hold to a lower bar than
  /// normal text.
  final bool largeText;

  /// Whether [ratio] clears the real WCAG threshold for [level] at this
  /// result's text size.
  bool passes(WcagLevel level) {
    final threshold = switch ((level, largeText)) {
      (WcagLevel.aa, true) => 3.0,
      (WcagLevel.aa, false) => 4.5,
      (WcagLevel.aaa, true) => 4.5,
      (WcagLevel.aaa, false) => 7.0,
    };
    return ratio >= threshold;
  }
}

/// Checks whether two colors have enough contrast to read comfortably,
/// using the real WCAG 2.x relative luminance and contrast ratio
/// formulas rather than an approximation: this is directly on-mission
/// for an app whose own design system claims a minimum contrast level,
/// and lets that claim actually be checked against arbitrary colors
/// (for example ones a user picks in a future theming screen).
class ContrastChecker {
  /// Creates a checker. Stateless: a single instance can be reused for
  /// any number of color pairs.
  const ContrastChecker();

  /// The contrast ratio between [foreground] and [background], judged
  /// as large text when [largeText] is true.
  ContrastResult check(
    RgbColor foreground,
    RgbColor background, {
    bool largeText = false,
  }) {
    final a = _relativeLuminance(foreground);
    final b = _relativeLuminance(background);
    final brightest = math.max(a, b);
    final dimmest = math.min(a, b);
    final ratio = (brightest + 0.05) / (dimmest + 0.05);
    return ContrastResult(ratio: ratio, largeText: largeText);
  }

  double _relativeLuminance(RgbColor color) {
    final r = _linearize(color.red / 255);
    final g = _linearize(color.green / 255);
    final b = _linearize(color.blue / 255);
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  double _linearize(double channel) {
    return channel <= 0.03928
        ? channel / 12.92
        : math.pow((channel + 0.055) / 1.055, 2.4).toDouble();
  }
}
