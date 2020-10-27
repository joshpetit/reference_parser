import 'package:reference_parser/src/util/VerseEnum.dart';
import 'package:reference_parser/src/data/Librarian.dart';
import 'package:reference_parser/src/model/BibleReference.dart';

class Verse extends BibleReference {
  @override
  final String reference;
  final int chapter;
  final int verseNumber;
  @override
  final bool isValid;
  final ReferenceType verseType;
  Verse(book, chapter, verseNumber)
      : reference = Librarian.createReferenceString(book, chapter, verseNumber),
        chapter = chapter,
        verseNumber = verseNumber,
        verseType = ReferenceType.VERSE,
        isValid = Librarian.verifyVerse(book, chapter, verseNumber),
        super(book);
}
