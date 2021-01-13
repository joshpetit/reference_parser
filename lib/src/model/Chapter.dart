import 'package:reference_parser/src/util/VerseEnum.dart';
import 'package:reference_parser/src/model/Verse.dart';
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

  final int startVerseNumber;
  final int endVerseNumber;
  final Verse startVerse;
  final Verse endVerse;

  List<Verse> _verses;

  /// The numerated chapter that this reference is within the book.
  final int chapterNumber;

  /// [ReferenceType.CHAPTER]
  ///
  /// This reference refers to a single chapter in the bible.
  @override
  final ReferenceType referenceType;

  @override
  final bool isValid;
  Chapter(String book, this.chapterNumber)
      : reference = Librarian.createReferenceString(book, chapterNumber),
        referenceType = ReferenceType.CHAPTER,
        startVerseNumber = 1,
        startVerse = Verse(book, chapterNumber, 1),
        endVerse = Librarian.getLastVerse(book, chapterNumber),
        endVerseNumber = Librarian.getLastVerseNumber(book, chapterNumber),
        isValid = Librarian.verifyReference(book, chapterNumber),
        super(book);

  /// The title cased osis representation for this chapter in
  /// Book chapter format.
  @override
  String get osisReference =>
      Librarian.createReferenceString(osisBook, chapterNumber);

  /// The uppercased paratext abbreviation for this chapter.
  /// in BOOK chapter format.
  @override
  String get abbrReference =>
      Librarian.createReferenceString(abbrBook, chapterNumber);

  /// The shortest standard abbreviation for this chapter in
  /// Book chapter format.
  @override
  String get shortReference =>
      Librarian.createReferenceString(shortBook, chapterNumber);

  @override
  List<Verse> get verses {
    if (_verses != null) {
      return _verses;
    }
    _verses = <Verse>[];
    for (int i = 1; i <= endVerseNumber; i++) {
      _verses.add(Verse(book, chapterNumber, i));
    }

    return _verses;
  }
}
