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
  final String? reference;

  /// The beginning chapter number in this reference.
  ///
  /// Initializes to 1 if unspecified.
  final int startChapterNumber;

  /// The first [Chapter] object within this reference.
  ///
  /// This field is not to useful yet, but is still present.
  /// If the reference is invalid will return null.
  /// ```
  /// var ref = parseReference('John 2-4');
  /// var firstChap = ref.startChapter;
  /// print(startChapter.chapterNumber); // 2
  /// ```
  final Chapter startChapter;

  /// The number for the last chapter in this reference.
  final int? endChapterNumber;

  /// The last [Chapter] object within this reference.
  ///
  /// This field is not to useful yet, but is still present.
  /// If the reference is invalid will return null.
  /// ```
  /// var ref = parseReference('John 2-4');
  /// var firstChap = ref.startChapter;
  /// print(endChapter.chapterNumber); // 4
  /// ```
  final Chapter? endChapter;

  /// The first verse number found in this reference.
  ///
  /// Defaults to 1.
  final int startVerseNumber;

  /// Caches the generated chapter objects
  /// when [Reference.chapters] is retrieved.
  List<Chapter>? _chapters;

  /// Caches the generated verse objects
  /// when [Reference.verses] is retrieved.
  List<Verse>? _verses;

  /// The [Verse] object representing the first verse in this reference.
  ///
  /// Returns the verse object of the first verse in the chapter if
  /// [startVerse] is not specified or the verse object of the first
  /// verse in the book if [startChapterNumber] is not specified.
  final Verse startVerse;

  /// The last verse number found in this reference.
  final int? endVerseNumber;

  /// The [Verse] object representing the last verse in this reference.
  ///
  /// Returns the verse object of the last verse in the chapter if
  /// [endVerse] is not specified or the verse object of the last verse in the
  /// book if [startChapterNumber] is not specified.
  final Verse? endVerse;

  /// The type of reference this is.
  @override
  final ReferenceType? referenceType;

  /// Whether this reference is within the bible.
  @override
  final bool isValid;

  /// The universal constructor, determines what kind of reference
  /// this is based on which fields are left `null`.
  Reference(String book, [int? schp, int? svn, int? echp, int? evn])
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
        referenceType =
            Librarian.identifyReferenceType(book, schp, svn, echp, evn),
        isValid = Librarian.verifyReference(book, schp, svn, echp, evn),
        super(book);

  /// Construct a [Reference] as a chapter.
  Reference.chapter(String book, int chapter) : this(book, chapter);

  /// Construct a [Reference] as a verse.
  Reference.verse(String book, int chapter, int verse)
      : this(book, chapter, verse);

  /// Construct a [Reference] as a chapter range such as
  /// Genesis 2-3.
  Reference.chapterRange(String book, int startChapter, int endChapter)
      : this(book, startChapter, null, endChapter);

  /// Construct a [Reference] as a verse range such as
  /// Genesis 2:3-4.
  Reference.verseRange(String book, int chapter, int startVerse, int endVerse)
      : this(book, chapter, startVerse, null, endVerse);

  /// The title cased representation for this reference.
  @override
  String? get osisReference => Librarian.createReferenceString(osisBook,
      startChapterNumber, startVerseNumber, endChapterNumber, endVerseNumber);

  /// The uppercased paratext abbreviation for this reference.
  @override
  String? get abbrReference => Librarian.createReferenceString(abbrBook,
      startChapterNumber, startVerseNumber, endChapterNumber, endVerseNumber);

  /// The shortest standard abbreviation for this reference.
  @override
  String? get shortReference => Librarian.createReferenceString(shortBook,
      startChapterNumber, startVerseNumber, endChapterNumber, endVerseNumber);

  /// Creates a list containing every chapter found
  /// within this reference.
  ///
  /// Onces called this list is cached so subsequent
  /// calls will be quicker.
  List<Chapter>? get chapters {
    if (_chapters != null) {
      return _chapters;
    }
    _chapters = <Chapter>[];
    for (var i = startChapterNumber; i <= endChapterNumber!; i++) {
      _chapters!.add(Chapter(book, i));
    }
    return _chapters;
  }

  /// Creates a list containing every verse found
  /// within this reference.
  ///
  /// Onces called this list is cached so subsequent
  /// calls will be quicker.
  List<Verse>? get verses {
    if (_verses != null) {
      return _verses;
    }
    _verses = <Verse>[];
    for (var i = startChapterNumber; i <= endChapterNumber!; i++) {
      var start = i == startChapterNumber ? startVerseNumber : 1;
      var end = i == endChapterNumber
          ? endVerseNumber!
          : Librarian.getLastVerseNumber(book, i)!;
      for (var j = start; j <= end; j++) {
        _verses!.add(Verse(book, i, j));
      }
    }

    return _verses;
  }
}
