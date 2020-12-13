import 'package:reference_parser/src/util/VerseEnum.dart';
import 'package:reference_parser/src/data/Librarian.dart';
import 'package:reference_parser/src/model/BibleReference.dart';

/// A reference to a single chapter in the bible.
///
/// This object is usually returned from accessing the
/// [Reference.startChapter] field.
/// ```
/// var chap = Chapter('Ps', 5);
/// print(chap.chapterNumber); // 5
/// print(chap.referenceType); // ReferenceType.CHAPTER
/// ```
class Chapter extends BibleReference {
  /// The reference in *book* *chapter* format, for example Psalm 5.
  @override
  final String reference;

  /// The numerated chapter that this reference is within the book.
  final int chapterNumber;

  /// [ReferenceType.CHAPTER]
  ///
  /// This reference refers to a single chapter in the bible.
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
