import 'package:reference_parser/src/data/Librarian.dart';
import 'package:reference_parser/src/model/Reference.dart';



var exp = RegExp(r'([1-3]?[^\s]+[A-Za-z ]+[^\d ]?) ?(\d+)?:?(\d+)?-?(\d+)?');

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

/// Create a reference from a string
Reference parseReference(String stringReference) {
  var pr = _parseString(stringReference);
  var bookNumber = Librarian.findBook(pr['book']);
  var book =
  bookNumber != null ? Librarian.getBookNames(bookNumber)[2] : pr['book'];
  var reference = Reference(
      book ?? pr['book'],
      pr['chapter'] == null ? null : int.parse(pr['chapter']),
      pr['startVerse'] == null ? null : int.parse(pr['startVerse']),
      pr['endVerse'] == null ? null : int.parse(pr['endVerse']));

  return reference;
}
