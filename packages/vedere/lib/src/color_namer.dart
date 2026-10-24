import 'package:meta/meta.dart';

/// A plain RGB color sample, each channel in the range 0 to 255.
@immutable
class RgbColor {
  /// Creates an RGB color sample.
  const RgbColor(this.red, this.green, this.blue);

  /// Red channel, 0 to 255.
  final int red;

  /// Green channel, 0 to 255.
  final int green;

  /// Blue channel, 0 to 255.
  final int blue;
}

/// Maps an [RgbColor] to the nearest of a small, fixed set of common
/// Italian color names.
///
/// This is a standalone utility: `lumen_sdk` has no color-sensing event
/// type yet, so nothing currently feeds live color samples into it. It
/// exists ahead of that wiring so the naming logic itself is complete
/// and tested.
class ColorNamer {
  static const Map<String, RgbColor> _namedColors = {
    'rosso': RgbColor(220, 20, 20),
    'verde': RgbColor(20, 140, 20),
    'blu': RgbColor(20, 20, 200),
    'giallo': RgbColor(230, 220, 20),
    'bianco': RgbColor(255, 255, 255),
    'nero': RgbColor(0, 0, 0),
    'arancione': RgbColor(240, 130, 20),
    'viola': RgbColor(130, 20, 160),
    'rosa': RgbColor(240, 150, 190),
    'marrone': RgbColor(120, 70, 30),
    'grigio': RgbColor(130, 130, 130),
  };

  /// The Italian name of the fixed-table entry nearest to [color], by
  /// Euclidean distance in RGB space.
  String nameOf(RgbColor color) {
    var bestName = _namedColors.keys.first;
    var bestDistance = double.infinity;

    for (final entry in _namedColors.entries) {
      final distance = _squaredDistance(color, entry.value);
      if (distance < bestDistance) {
        bestDistance = distance;
        bestName = entry.key;
      }
    }

    return bestName;
  }

  double _squaredDistance(RgbColor a, RgbColor b) {
    final dr = a.red - b.red;
    final dg = a.green - b.green;
    final db = a.blue - b.blue;
    return (dr * dr + dg * dg + db * db).toDouble();
  }
}
