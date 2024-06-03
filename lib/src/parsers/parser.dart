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
Reference parseReference(String stringReference, {bool ignoreIs = false}) {
  if (ignoreIs) {
    stringReference = stringReference.replaceAll(RegExp(r'\bis\b', caseSensitive: false), '');
  }
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
List<Reference> parseAllReferences(String stringReference, {bool ignoreIs = false}) {
  if (ignoreIs) {
    stringReference = stringReference.replaceAll(RegExp(r'\bis\b', caseSensitive: false), '');
  }
  var refs = <Reference>[];
  var matches = _exp.allMatches(stringReference);
  matches.forEach((x) => refs.add(_createRefFromMatch(x)));
  return refs;
}

String parseReferencesAndReplaceString(String stringReference, {bool ignoreIs = false}) {
   if (ignoreIs) {
    stringReference = stringReference.replaceAll(
        RegExp(r'\bis\b', caseSensitive: false), '%%');
  }

  var matches = _exp.allMatches(stringReference);
  var originalString = stringReference;

  matches.forEach((x) {
    var reference = _createRefFromMatch(x);
    var matchedString = x.group(0);
    if (matchedString != null) {
      var punct = RegExp(r'[.,;!?]\s*$');
      var replacementString = reference.toString();

      if (punct.hasMatch(matchedString)) {
        if (matchedString.length > 1) {
          replacementString += matchedString[matchedString.length - 2];
        }
      }
      replacementString += ' ';

      originalString =
          originalString.replaceFirst(matchedString, replacementString);
    }
  });

  if (ignoreIs) {
    originalString = originalString.replaceAll('%%', 'is');
  }

  return originalString;
}
Reference _createRefFromMatch(RegExpMatch match) {
  var pr = match.groups([0, 1, 2, 3, 4, 5]);
  var book = pr[1]!.replaceAllMapped(RegExp(r'(\d+)\s?'), (match) {
    return '${match.group(1)} ';
  });

  return Reference(
    Librarian.getBookNames(book)['name'] ?? pr[1]!,
    pr[2] == null ? null : int.parse(pr[2]!),
    pr[3] == null ? null : int.parse(pr[3]!),
    pr[4] != null && (pr[3] == null || pr[5] != null)
        ? int.parse(pr[4]!)
        : null,
    pr[5] != null
        ? int.parse(pr[5]!)
        : pr[4] != null && pr[3] != null
            ? int.parse(pr[4]!)
            : null,
  );
}

RegExp _createFullRegex() {
  var books = BibleData.bookNames.expand((i) => i).toList();
  books.addAll(BibleData.variants.keys);
  var regBooks = books.map((e) => e.replaceAll(' ', '[ ]?')).join('\\b|\\b');
  var expression =
      '(\\b$regBooks\\b) *(\\d+)?[ :.]*(\\d+)?[— -]*(\\d+)?[ :.]*(\\d+)?';
  var exp = RegExp(expression, caseSensitive: false);
  return exp;
}
