import 'package:reference_parser/src/util/VerseEnum.dart';
import 'package:reference_parser/src/data/Librarian.dart';
import 'package:reference_parser/src/model/BibleReference.dart';

class Verse extends BibleReference {
  @override
  final String reference;
  final int chapter;
  final int verseNumber;
  @override
  ReferenceType referenceType;
  @override
  final bool isValid;
  Verse(book, chapter, verseNumber)
      : reference = Librarian.createReferenceString(book, chapter, verseNumber),
        chapter = chapter,
        verseNumber = verseNumber,
        referenceType = ReferenceType.VERSE,
        isValid = Librarian.verifyVerse(book, chapter, verseNumber),
        super(book);
}
