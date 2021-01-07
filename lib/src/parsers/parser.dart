import 'package:reference_parser/src/data/Librarian.dart';
import 'package:reference_parser/src/data/BibleData.dart';
import 'package:reference_parser/src/model/Reference.dart';

final _exp = _createFullRegex();

/// Finds the first reference from within a string.
///
///
/// ```dart
/// parseReference('I love James 4:5 and Matthew 2:4');
///```
/// Returns a [Reference] object of James :45.
///
/// **Note**: The word 'is' will be parsed as the book of Isaiah.
/// An efficient workaround is in the works.
Reference parseReference(String stringReference) {
  var match = _exp.firstMatch(stringReference);
  if (match == null) return Reference('');
  return _createRefFromMatch(match);
}

/// Finds all the references within a string. Returns an empty
/// list when no references are found.
///
/// ```dart
/// parseAllReferences('I love James 4:5 and Matthew 2:4');
///```
/// Returns a list of [Reference] objects with James 4:5
/// and Matthew 2:4
///
/// **Note**: The word 'is' will be parsed as the book of Isaiah.
/// An efficient workaround is in the works.
List<Reference> parseAllReferences(String stringReference) {
  var refs = <Reference>[];
  var matches = _exp.allMatches(stringReference);
  if (matches == null) return refs;
  matches.forEach((x) => {
        if (x[0].trim() != 'is') refs.add(_createRefFromMatch(x)),
      });
  return refs;
}

Reference _createRefFromMatch(RegExpMatch match) {
  var pr = match.groups([0, 1, 2, 3, 4]);
  if (pr[3] == null) {
    return Reference(
        Librarian.getBookNames(pr[1])['name'] ?? pr[1],
        pr[2] == null ? null : int.parse(pr[2]),
        null,
        pr[4] == null ? null : int.parse(pr[4]));
  }

  return Reference(
    Librarian.getBookNames(pr[1])['name'] ?? pr[1],
    pr[2] == null ? null : int.parse(pr[2]),
    pr[3] == null ? null : int.parse(pr[3]),
    pr[2] == null ? null : int.parse(pr[2]),
    pr[4] == null ? null : int.parse(pr[4]),
  );
}

RegExp _createFullRegex() {
  var books = BibleData.bookNames.expand((i) => i).toList();
  books.addAll(BibleData.variants.keys);
  var regBooks = books.join('\\b|\\b');
  var expression = '(\\$regBooks\\b) *(\\d+)?[ :.]*(\\d+)?[— -]*(\\d+)?';
  var exp = RegExp(expression, caseSensitive: false);
  return exp;
}
