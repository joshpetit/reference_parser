import 'package:reference_parser/src/util/VerseEnum.dart';
import 'package:reference_parser/src/data/Librarian.dart';

abstract class BibleReference {
  final String reference;
  final String book;
  final int bookNumber;
  final ReferenceType referenceType;
  final bool isValid;

  BibleReference(book)
      : book = book,
        reference = Librarian.createReferenceString(book),
        bookNumber = Librarian.findBook(book),
        referenceType = Librarian.identifyReferenceType(book),
        isValid = Librarian.verifyVerse(book);
}
