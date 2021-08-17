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
  /// The reference in book chapter format, for example Psalm 5.
  @override
  final String? reference;

  /// The first verse within this chapter.
  final int startVerseNumber;

  /// The last verse within this chapter.
  final int? endVerseNumber;

  /// The first verse in this chapter represented
  /// by a [Verse] object.
  final Verse startVerse;

  /// The last verse in this chapter represented
  /// by a [Verse] object.
  final Verse? endVerse;

  /// Caches the generated verse objects
  /// when [Reference.verses] is retrieved.
  List<Verse>? _verses;

  /// The numerated chapter that this reference is within the book.
  final int chapterNumber;

  /// [ReferenceType.CHAPTER]
  ///
  /// This reference refers to a single chapter in the bible.
  @override
  final ReferenceType referenceType;

  /// Whether this chapter is found within the bible.
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
  String? get osisReference =>
      Librarian.createReferenceString(osisBook, chapterNumber);

  /// The uppercased paratext abbreviation for this chapter.
  /// in BOOK chapter format.
  @override
  String? get abbrReference =>
      Librarian.createReferenceString(abbrBook, chapterNumber);

  /// The shortest standard abbreviation for this chapter in
  /// Book chapter format.
  @override
  String? get shortReference =>
      Librarian.createReferenceString(shortBook, chapterNumber);

  /// Creates a list containing every verse found
  /// within this chapter.
  ///
  /// Onces called this list is cached so subsequent
  /// calls will be quicker.
  List<Verse>? get verses {
    if (_verses != null) {
      return _verses;
    }
    _verses = <Verse>[];
    for (var i = 1; i <= endVerseNumber!; i++) {
      _verses!.add(Verse(book, chapterNumber, i));
    }

    return _verses;
  }
}
