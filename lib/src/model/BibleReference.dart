import 'package:reference_parser/src/util/VerseEnum.dart';
import 'package:reference_parser/src/data/Librarian.dart';

abstract class BibleReference {
  final String reference;
  final String book;
  final Map<String, String> _bookNames;
  final int bookNumber;
  final ReferenceType referenceType;
  final bool isValid;

  BibleReference(book)
      : book = book,
        reference = Librarian.createReferenceString(book),
        bookNumber = Librarian.findBook(book),
        referenceType = Librarian.identifyReferenceType(book),
        _bookNames = Librarian.getBookNames(book),
        isValid = Librarian.verifyVerse(book);

  @override
  String toString() {
    return reference;
  }

  String get osis => _bookNames['osis'];
  String get abbr => _bookNames['abbr'];
  String get short => _bookNames['short'];
}
