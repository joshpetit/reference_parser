import 'package:reference_parser/src/util/VerseEnum.dart';
import 'package:reference_parser/src/data/Librarian.dart';
import 'package:reference_parser/src/model/BibleReference.dart';

/// A bible reference that contains the book, chapter, and a single verse number.
///
/// When instantiated by the [Reference] class, this object usually refers to the
/// reference object's first or last verse within that reference.
class Verse extends BibleReference {
  /// The book, chapter, and verse number.
  ///
  /// The full book name of the reference in Book chapter:verse format
  @override
  final String? reference;

  /// The chapter number this verse is within.
  final int? chapterNumber;

  /// The verse number this verse refers to within a chapter.
  final int verseNumber;

  /// [ReferenceType.VERSE].
  @override
  final ReferenceType referenceType;

  /// Whether this verse is found within the bible.
  @override
  final bool isValid;
  Verse(String book, this.chapterNumber, int verseNumber)
      : reference =
            Librarian.createReferenceString(book, chapterNumber, verseNumber),
        verseNumber = verseNumber,
        referenceType = ReferenceType.VERSE,
        isValid = Librarian.verifyReference(book, chapterNumber, verseNumber),
        super(book);

  /// The title cased osis representation for this verse in
  /// Book chapter:verse format.
  @override
  String? get osisReference =>
      Librarian.createReferenceString(osisBook, chapterNumber, verseNumber);

  /// The uppercased paratext abbreviation for this verse.
  /// in BOOKchapter:verse format.
  @override
  String? get abbrReference =>
      Librarian.createReferenceString(abbrBook, chapterNumber, verseNumber);

  /// The shortest standard abbreviation for this verse in
  /// Book chapter:verse format.
  @override
  String? get shortReference =>
      Librarian.createReferenceString(shortBook, chapterNumber, verseNumber);
}
