/// Which textual pattern [ExpiryDateParser] matched.
enum ExpiryDateFormat {
  /// `dd/mm/yyyy` or `dd/mm/yy`.
  dayMonthYearSlash,

  /// `dd-mm-yyyy` or `dd-mm-yy`.
  dayMonthYearDash,

  /// `SCAD 12/2026` style, month and year only. The day is taken as
  /// the last day of that month, since the exact day is not printed.
  monthYearOnly,

  /// `da consumarsi preferibilmente entro il gg/mm/aaaa`.
  entroIlPhrase,

  /// `12 DIC 2026` style, using an Italian month abbreviation.
  italianMonthName,
}

/// Result of parsing a piece of OCR text for an expiry date.
class ExpiryDateResult {
  /// Creates a result. Use [ExpiryDateResult.notFound] when no date was
  /// recognized.
  const ExpiryDateResult({required this.date, required this.format});

  /// A result representing no recognized date.
  const ExpiryDateResult.notFound()
      : date = null,
        format = null;

  /// The parsed date, or `null` if none was recognized.
  final DateTime? date;

  /// Which pattern matched, or `null` if none did.
  final ExpiryDateFormat? format;

  /// Whether a date was recognized.
  bool get isFound => date != null;
}

/// Extracts an expiry date from OCR text recognized on Italian product
/// packaging.
///
/// Patterns are tried from most to least specific, so a phrase like
/// "da consumarsi preferibilmente entro il 25/12/2026" is attributed to
/// [ExpiryDateFormat.entroIlPhrase] rather than the more generic
/// [ExpiryDateFormat.dayMonthYearSlash].
class ExpiryDateParser {
  static const Map<String, int> _italianMonths = {
    'gen': 1,
    'feb': 2,
    'mar': 3,
    'apr': 4,
    'mag': 5,
    'giu': 6,
    'lug': 7,
    'ago': 8,
    'set': 9,
    'ott': 10,
    'nov': 11,
    'dic': 12,
  };

  static final RegExp _entroPattern = RegExp(
    r'entro\s+(?:il\s+)?(\d{1,2})[/\-](\d{1,2})[/\-](\d{2,4})',
    caseSensitive: false,
  );

  static final RegExp _slashPattern = RegExp(r'(\d{1,2})/(\d{1,2})/(\d{2,4})');

  static final RegExp _dashPattern = RegExp(r'(\d{1,2})-(\d{1,2})-(\d{2,4})');

  static final RegExp _monthNamePattern = RegExp(
    r'(\d{1,2})\s+(gen|feb|mar|apr|mag|giu|lug|ago|set|ott|nov|dic)\w*\s+(\d{4})',
    caseSensitive: false,
  );

  static final RegExp _monthYearPattern = RegExp(
    r'scad\.?\s*(\d{1,2})[/\-](\d{4})',
    caseSensitive: false,
  );

  /// Parses [text] and returns the first expiry date recognized, or a
  /// not-found result.
  ExpiryDateResult parse(String text) {
    final normalized = text.trim();

    final entroMatch = _entroPattern.firstMatch(normalized);
    if (entroMatch != null) {
      final date = _buildDayMonthYear(
        entroMatch.group(1)!,
        entroMatch.group(2)!,
        entroMatch.group(3)!,
      );
      if (date != null) {
        return ExpiryDateResult(
          date: date,
          format: ExpiryDateFormat.entroIlPhrase,
        );
      }
    }

    final slashMatch = _slashPattern.firstMatch(normalized);
    if (slashMatch != null) {
      final date = _buildDayMonthYear(
        slashMatch.group(1)!,
        slashMatch.group(2)!,
        slashMatch.group(3)!,
      );
      if (date != null) {
        return ExpiryDateResult(
          date: date,
          format: ExpiryDateFormat.dayMonthYearSlash,
        );
      }
    }

    final dashMatch = _dashPattern.firstMatch(normalized);
    if (dashMatch != null) {
      final date = _buildDayMonthYear(
        dashMatch.group(1)!,
        dashMatch.group(2)!,
        dashMatch.group(3)!,
      );
      if (date != null) {
        return ExpiryDateResult(
          date: date,
          format: ExpiryDateFormat.dayMonthYearDash,
        );
      }
    }

    final monthNameMatch = _monthNamePattern.firstMatch(normalized);
    if (monthNameMatch != null) {
      final month = _italianMonths[monthNameMatch.group(2)!.toLowerCase()];
      if (month != null) {
        final date = _validDateOrNull(
          int.parse(monthNameMatch.group(3)!),
          month,
          int.parse(monthNameMatch.group(1)!),
        );
        if (date != null) {
          return ExpiryDateResult(
            date: date,
            format: ExpiryDateFormat.italianMonthName,
          );
        }
      }
    }

    final monthYearMatch = _monthYearPattern.firstMatch(normalized);
    if (monthYearMatch != null) {
      final month = int.parse(monthYearMatch.group(1)!);
      final year = int.parse(monthYearMatch.group(2)!);
      if (month >= 1 && month <= 12) {
        final lastDayOfMonth = DateTime(year, month + 1, 0).day;
        final date = _validDateOrNull(year, month, lastDayOfMonth);
        if (date != null) {
          return ExpiryDateResult(
            date: date,
            format: ExpiryDateFormat.monthYearOnly,
          );
        }
      }
    }

    return const ExpiryDateResult.notFound();
  }

  DateTime? _buildDayMonthYear(String dayStr, String monthStr, String yearStr) {
    final day = int.parse(dayStr);
    final month = int.parse(monthStr);
    var year = int.parse(yearStr);
    if (year < 100) {
      year += 2000;
    }
    return _validDateOrNull(year, month, day);
  }

  DateTime? _validDateOrNull(int year, int month, int day) {
    if (month < 1 || month > 12) return null;
    final date = DateTime(year, month, day);
    // DateTime silently rolls over an out-of-range day into the next
    // month (for example day 31 of a 30-day month); reject that rather
    // than returning a date that was never actually printed.
    if (date.year != year || date.month != month || date.day != day) {
      return null;
    }
    return date;
  }
}
