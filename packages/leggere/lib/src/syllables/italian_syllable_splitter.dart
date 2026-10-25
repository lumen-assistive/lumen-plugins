import 'package:meta/meta.dart';

const String _vowels = 'aeiouAEIOUaeiouAEIOUàèéìòùÀÈÉÌÒÙ';

/// Two-letter consonant sequences that represent a single consonant
/// sound in Italian spelling and are never split between syllables.
const List<String> _digraphs = ['ch', 'gh', 'gn', 'gl', 'sc'];

/// Consonants that, followed by [_liquidConsonants], form a blend
/// ("muta cum liquida") that stays together and joins the following
/// vowel, for example the "tr" in "pa-tria" or the "pr" in "sem-pre".
const String _mutaConsonants = 'bcdfgptv';

const String _liquidConsonants = 'lr';

bool _isVowel(String letter) => _vowels.contains(letter);

/// Splits a single Italian word into syllables, following the
/// orthographic rules taught in Italian schools.
///
/// The rules applied, in order: a lone consonant between two vowel
/// groups joins the following vowel; "s impura" (an s followed by one
/// or more consonants) is never split off the vowel that follows it; a
/// small set of digraphs (`ch`, `gh`, `gn`, `gl`, `sc`) and "muta cum
/// liquida" blends (a plosive or fricative followed by `l` or `r`) stay
/// together and join the following vowel; any other consonant pair
/// splits evenly between the two syllables.
///
/// This covers the purely orthographic rules, not full lexical
/// hyphenation: Italian also distinguishes a diphthong from a hiatus
/// (adjacent vowels kept in separate syllables, as in the "i-a" of
/// "zia" versus the single-syllable "ia" of "mia") based on word
/// stress, which cannot be recovered from spelling alone. This splitter
/// keeps every run of adjacent vowel letters as one syllable nucleus, a
/// documented simplification rather than a claim of full lexical
/// accuracy.
@immutable
class ItalianSyllableSplitter {
  /// Creates a splitter. Stateless: a single instance can be reused for
  /// any number of words.
  const ItalianSyllableSplitter();

  /// Splits [word] into its syllables, in reading order.
  ///
  /// Returns `[word]` unchanged if it contains no vowels, for example
  /// an initialism, since there is then no vowel nucleus to split on.
  List<String> split(String word) {
    if (word.isEmpty) return [word];

    final vowelRunStarts = <int>[];
    final vowelRunEnds = <int>[];

    var index = 0;
    while (index < word.length) {
      if (_isVowel(word[index])) {
        final start = index;
        while (index < word.length && _isVowel(word[index])) {
          index++;
        }
        vowelRunStarts.add(start);
        vowelRunEnds.add(index);
      } else {
        index++;
      }
    }

    if (vowelRunStarts.isEmpty) return [word];

    final boundaries = <int>[];
    for (var run = 0; run < vowelRunStarts.length - 1; run++) {
      final clusterStart = vowelRunEnds[run];
      final clusterEnd = vowelRunStarts[run + 1];
      final cluster = word.substring(clusterStart, clusterEnd).toLowerCase();
      boundaries
          .add(clusterStart + _consonantsKeptWithPreviousSyllable(cluster));
    }

    final syllables = <String>[];
    var start = 0;
    for (final boundary in boundaries) {
      syllables.add(word.substring(start, boundary));
      start = boundary;
    }
    syllables.add(word.substring(start));
    return syllables;
  }

  /// How many letters at the start of a consonant [cluster] (already
  /// lowercase) belong to the syllable before it; the rest join the
  /// syllable after it.
  int _consonantsKeptWithPreviousSyllable(String cluster) {
    if (cluster.length == 1) return 0;
    if (cluster.startsWith('s')) return 0;

    if (cluster.length == 2) {
      if (_digraphs.contains(cluster)) return 0;
      if (_isBlend(cluster)) return 0;
      return 1;
    }

    final lastTwo = cluster.substring(cluster.length - 2);
    if (_digraphs.contains(lastTwo) || _isBlend(lastTwo)) {
      return cluster.length - 2;
    }
    return cluster.length - 1;
  }

  bool _isBlend(String twoLetters) =>
      _mutaConsonants.contains(twoLetters[0]) &&
      _liquidConsonants.contains(twoLetters[1]);
}
