import 'package:reference_parser/src/data/Librarian.dart';
import 'package:reference_parser/src/data/BibleData.dart';
import 'package:reference_parser/src/model/Reference.dart';

final _exp = _createFullRegex();

Map<String, String> _parseString(String reference) {
  var match = _exp.firstMatch(reference);
  if (match == null) return null;
  var thing = match.groups([0, 1, 2, 3, 4]);
  return {
    'reference': thing[0],
    'book': thing[1],
    'chapter': thing[2],
    'startVerse': thing[3],
    'endVerse': thing[4],
  };
}

/// Finds the first reference from within a string.
///
///
/// ```dart
/// parseReference('I love James 4:5 and Matthew 2:4');
///```
/// Returns a reference object of James :45
Reference parseReference(String stringReference) {
  var pr = _parseString(stringReference);
  if (pr == null) return Reference('');
  var book = Librarian.getBookNames(pr['book'])['name'] ?? pr['book'];
  var reference = Reference(
      book,
      pr['chapter'] == null ? null : int.parse(pr['chapter']),
      pr['startVerse'] == null ? null : int.parse(pr['startVerse']),
      pr['endVerse'] == null ? null : int.parse(pr['endVerse']));

  return reference;
}

/// Directly create a reference, parses [book] for variant spellings
///
/// initializes the [Reference] book to the long name of the passed
/// in book parameter
Reference createReference(String book,
    [int chapter, int startVerse, int endVerse]) {
  book = Librarian.getBookNames(book)['name'] ?? book;
  return Reference(
      book, chapter = chapter, startVerse = startVerse, endVerse = endVerse);
}

RegExp _createFullRegex() {
  var books = BibleData.bookNames.expand((i) => i).toList();
  books.addAll(BibleData.variants.keys);
  var regBooks = books.join('\\b|\\b');
  var expression = '(\\b$regBooks\\b) ?(\\d+)?:?(\\d+)?-?(\\d+)?';
  var exp = RegExp(expression, caseSensitive: false);
  return exp;
}
