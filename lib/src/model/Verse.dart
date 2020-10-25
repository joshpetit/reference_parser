import 'package:reference_parser/src/util/VerseEnum.dart';
import 'package:reference_parser/src/data/Librarian.dart';
import 'package:reference_parser/src/model/BibleReference.dart';

class Verse extends BibleReference {
  final String reference;
  final String book;
  final int bookNumber;
  final int chapter;
  final int verseNumber;
  final bool isValid;
  final ReferenceType verseType;
  Verse(book, chapter, verseNumber)
      : reference = Librarian.createReferenceString(book, chapter, verseNumber),
        book = book,
        bookNumber = Librarian.findBook(book),
        chapter = chapter,
        verseNumber = verseNumber,
        verseType = ReferenceType.VERSE,
        isValid = Librarian.verifyVerse(book, chapter, verseNumber),
        super(book);
}
