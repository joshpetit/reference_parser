import 'package:reference_parser/data/Librarian.dart';

import 'model/Reference.dart';

var exp = RegExp(r'([1-3]?[^\s]+[A-Za-z ]+[^\d ]) ?(\d+)?:?(\d+)?-?(\d+)?');

Map<String, String> _parseString(String reference) {
  var match = exp.firstMatch(reference);
  var thing = match.groups([0, 1, 2, 3, 4]);
  return {
    'reference': thing[0],
    'book': thing[1],
    'chapter': thing[2],
    'startVerse': thing[3],
    'endVerse': thing[4],
  };
}

Reference createReference(String stringReference) {
  var pr = _parseString(stringReference);
  var bookNumber = Librarian.findBook(pr['book']);
  var book = Librarian.getBookNames(bookNumber)[2];
  var reference = Reference(
      book ?? pr['book'],
      pr['chapter'] == null ? null : int.parse(pr['chapter']),
      pr['startVerse'] == null ? null : int.parse(pr['chapter']),
      pr['endVerse'] == null ? null : int.parse(pr['chapter']));

  return reference;
}
