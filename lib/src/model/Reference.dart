import 'package:reference_parser/src/data/Librarian.dart';
import 'package:reference_parser/src/model/Verse.dart';
import 'package:reference_parser/src/model/Chapter.dart';
import 'package:reference_parser/src/model/BibleReference.dart';
import 'package:reference_parser/src/util/VerseEnum.dart';

/// A general BibleReference, can contain all [ReferenceType]s.
///
/// Reference objects are general references that can refer to either a single verse, a range of verses,
/// a single chapter, or entire an entire book. This is the returned type when using [parseReference]
/// and [parseAllReferences].
class Reference extends BibleReference {
  /// The representation of the reference.
  @override
  final String reference;

  /// The beginning chapter number in this reference.
  ///
  /// Initializes to `null` if unspecified.
  final int startChapterNumber;

  final Chapter startChapter;

  final int endChapterNumber;

  final Chapter endChapter;

  /// The first verse number found in this reference.
  ///
  /// Defaults to 1.
  final int startVerseNumber;

  /// The [Verse] object representing the first verse in this reference.
  ///
  /// Returns the verse object of the first verse in the chapter if
  /// [startVerse] is not specified or the verse object of the first
  /// verse in the book if [startChapterNumber] is not specified.
  final Verse startVerse;

  /// The last verse number found in this reference.
  final int endVerseNumber;

  /// The [Verse] object representing the last verse in this reference.
  ///
  /// Returns the verse object of the last verse in the chapter if
  /// [endVerse] is not specified or the verse object of the last verse in the
  /// book if [startChapterNumber] is not specified.
  final Verse endVerse;

  /// The type of reference.
  /// [ReferenceType.VERSE] [ReferenceType.RANGE],[ReferenceType.CHAPTER], [ReferenceType.BOOK].
  @override
  final ReferenceType referenceType;

  /// Whether this reference is within the bible.
  @override
  final bool isValid;

  Reference(String book, [int schp, int svn, int echp, int evn])
      : startChapterNumber = schp ?? 1,
        startChapter = schp != null ? Chapter(book, schp) : Chapter(book, 1),
        startVerseNumber = svn ?? 1,
        startVerse = svn != null
            ? Verse(book, schp, svn)
            : schp != null
                ? Verse(book, schp, 1)
                : Verse(book, 1, 1),
        endChapterNumber = echp ?? schp ?? Librarian.getLastChapterNumber(book),
        endChapter = echp != null
            ? Chapter(book, echp)
            : schp != null
                ? Chapter(book, schp)
                : Librarian.getLastChapter(book),
        endVerseNumber = evn ?? svn ?? Librarian.getLastVerseNumber(book, echp),
        endVerse = evn != null
            ? Verse(book, schp, evn)
            : svn != null
                ? Verse(book, schp, svn)
                : Librarian.getLastVerse(book, schp),
        reference = Librarian.createReferenceString(book, schp, svn, echp, evn),
        referenceType = Librarian.identifyReferenceType(book, schp, svn, evn),
        isValid = Librarian.verifyReference(book, schp, svn, echp, evn),
        super(book);
}
