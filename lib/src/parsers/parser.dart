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
/// Returns a reference object of James :45.
Reference parseReference(String stringReference) {
  var match = _exp.firstMatch(stringReference);
  if (match == null) return Reference('');
  return _createRefFromMatch(match);
}

List<Reference> parseAllReferences(String stringReference) {
  List<Reference> refs = [];
  var matches = _exp.allMatches(stringReference);
  if (matches == null) return refs;
  matches.forEach((x) => refs.add(_createRefFromMatch(x)));
  return refs;
}

Reference _createRefFromMatch(RegExpMatch match) {
  var pr = match.groups([0, 1, 2, 3, 4]);
  return Reference(
      Librarian.getBookNames(pr[1])['name'] ?? pr[1],
      pr[2] == null ? null : int.parse(pr[2]),
      pr[3] == null ? null : int.parse(pr[3]),
      pr[4] == null ? null : int.parse(pr[4]));
}

RegExp _createFullRegex() {
  var books = BibleData.bookNames.expand((i) => i).toList();
  books.addAll(BibleData.variants.keys);
  var regBooks = books.join('\\b|\\b');
  var expression = '(\\b$regBooks\\b) ?(\\d+)?:?(\\d+)?-?(\\d+)?';
  var exp = RegExp(expression, caseSensitive: false);
  return exp;
}
