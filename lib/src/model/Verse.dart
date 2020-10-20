import 'package:reference_parser/src/util/VerseEnum.dart';
import 'package:reference_parser/src/data/Librarian.dart';

class Verse {
  final String reference;
  final String book;
  final int bookNumber;
  final int chapter;
  final int verseNumber;
  final bool isValid;
  final ReferenceType verseType;
  Verse(book, chapter, verseNumber, verseType)
      : reference = Librarian.createReferenceString(book, chapter, verseNumber),
        book = book,
        bookNumber = Librarian.findBook(book),
        chapter = chapter,
        verseNumber = verseNumber,
        verseType = ReferenceType.VERSE,
        isValid = Librarian.verifyVerse(book, chapter, verseNumber);
}
