import 'package:reference_parser/src/util/VerseEnum.dart';
import 'package:reference_parser/src/data/Librarian.dart';
import 'package:reference_parser/src/model/BibleReference.dart';

class Chapter extends BibleReference {
  @override
  final String reference;

  final int chapterNumber;

  @override
  ReferenceType referenceType;

  @override
  final bool isValid;
  Chapter(String book, this.chapterNumber)
      : reference = Librarian.createReferenceString(book, chapterNumber),
        referenceType = ReferenceType.CHAPTER,
        isValid = Librarian.verifyReference(book, chapterNumber),
        super(book);
}
