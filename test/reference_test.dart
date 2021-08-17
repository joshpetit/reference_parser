import 'package:reference_parser/src/model/Reference.dart';
import 'package:reference_parser/src/model/Verse.dart';
import 'package:reference_parser/src/model/Chapter.dart';
import 'package:reference_parser/src/util/VerseEnum.dart';
import 'package:test/test.dart';

void main() {
  test('Creation of reference to a book', () {
    var ref = Reference('James');
    expect(ref.book, equals('James'));
    expect(ref.reference, equals('James'));
    expect(ref.startVerseNumber, equals(1));
    expect(ref.endVerseNumber, equals(20),
        reason: 'The last verse in James is 20');
    expect(ref.startChapterNumber, equals(1));
    expect(ref.referenceType, equals(ReferenceType.BOOK));
  });

  test('Creation of book and chapter reference', () {
    var ref = Reference('James', 5);
    expect(ref.reference, equals('James 5'));
    expect(ref.book, equals('James'));
    expect(ref.startChapterNumber, equals(5));
    expect(ref.startVerseNumber, equals(1));
    expect(ref.endVerseNumber, equals(20));
    expect(ref.referenceType, equals(ReferenceType.CHAPTER));
  });

  test('Creation of chapter range references', () {
    var ref = Reference('Matthew', 5, null, 6);
    expect(ref.reference, equals('Matthew 5-6'));
    expect(ref.book, equals('Matthew'));
    expect(ref.startChapterNumber, equals(5));
    expect(ref.endChapterNumber, equals(6));
    expect(ref.startVerseNumber, equals(1));
    expect(ref.endVerseNumber, equals(34));
    expect(ref.referenceType, equals(ReferenceType.CHAPTER_RANGE));
  });

  test('Creation of verse reference', () {
    var ref = Reference('James', 5, 2);
    expect(ref.reference, equals('James 5:2'));
    expect(ref.book, equals('James'));
    expect(ref.startChapterNumber, equals(5));
    expect(ref.startVerseNumber, equals(2));
    expect(ref.endVerseNumber, equals(2));
    expect(ref.referenceType, equals(ReferenceType.VERSE));
  });

  test('Creation of range of verses reference', () {
    var ref = Reference('James', 5, 2, 5, 3);
    expect(ref.reference, equals('James 5:2-3'));
    expect(ref.book, equals('James'));
    expect(ref.startChapterNumber, equals(5));
    expect(ref.startVerseNumber, equals(2));
    expect(ref.endVerseNumber, equals(3));
    expect(ref.referenceType, equals(ReferenceType.VERSE_RANGE));
  });

  test('Verification works correctly', () {
    var ref = Reference('James', 2, 4);
    expect(ref.isValid, equals(true), reason: 'Passage should be valid');

    ref = Reference('James', 15, 5, 3);
    expect(ref.isValid, equals(false), reason: 'Chapter should not be valid');

    ref = Reference('James', 15, -5, 3);
    expect(ref.isValid, equals(false),
        reason: 'Negative values should return false');

    ref = Reference('Psalms', 1, 5, 1, 100);
    expect(ref.isValid, equals(false), reason: 'End verse should not be valid');
  });

  test('Reference.book field initializes to full book name', () {
    var ref = Reference('Ps');
    expect(ref.book, equals('Psalms'));
  });

  test('Book numbers correctly initialized', () {
    var ref = Reference('Genesis');
    expect(ref.bookNumber, equals(1), reason: 'Genesis is the 1st book');

    ref = Reference('John');
    expect(ref.bookNumber, equals(43), reason: 'John is the 43rd book');

    ref = Reference('Revelation');
    expect(ref.bookNumber, equals(66), reason: 'Revelation is the 66th book');

    ref = Reference('Joseph');
    expect(ref.bookNumber, equals(null),
        reason: 'The Gospel of Joseph does not exist');
    expect(ref.endVerseNumber, equals(null));
  });

  test('Verse object creation', () {
    var verse = Verse('Genesis', 2, 3);
    expect(verse.book, equals('Genesis'));
    expect(verse.chapterNumber, equals(2));
    expect(verse.bookNumber, equals(1));
    expect(verse.verseNumber, equals(3));
    expect(verse.reference, equals('Genesis 2:3'));
    expect(verse.isValid, equals(true));
  });

  test('Chapter object creation', () {
    var chapter = Chapter('Genesis', 2);
    expect(chapter.reference, equals('Genesis 2'));
    expect(chapter.book, equals('Genesis'));
    expect(chapter.chapterNumber, equals(2));
    expect(chapter.bookNumber, equals(1));
    expect(chapter.endVerseNumber, equals(25));
    expect(chapter.isValid, equals(true));

    expect(chapter.startVerse.reference, equals('Genesis 2:1'));
    expect(chapter.endVerse!.reference, equals('Genesis 2:25'));

    chapter = Chapter('Genesis', 60);
    expect(chapter.isValid, equals(false));
    expect(chapter.endVerse, equals(null));
  });

  test('Reference [start/end]Verse objects for single verse references', () {
    var ref = Reference('John', 2, 4);
    expect(ref.endVerse!.verseNumber, ref.startVerse.verseNumber,
        reason: 'This is a single verse Reference');

    expect(ref.startVerse.book, equals('John'),
        reason: 'All verses have a book');

    expect(ref.startVerse.chapterNumber, equals(2),
        reason: 'Verse should have a chapter');

    expect(ref.startVerse.verseNumber, equals(4),
        reason: 'Verse should have a verse number');

    expect(ref.startVerse.isValid, equals(true),
        reason: 'Verse is a valid reference');

    ref = Reference('Joseph', 2, 5);
    expect(ref.startVerse.isValid, equals(false),
        reason: 'Joseph is not a book in the bible');
  });

  test('Reference [start/end]Verse objects for range references', () {
    var ref = Reference('Genesis', 2, 5, 2, 10);
    expect(ref.endVerse!.book, equals('Genesis'));
    expect(ref.endVerse!.verseNumber, equals(10));
    expect(ref.endVerse!.chapterNumber, equals(2));
    expect(ref.endVerse!.isValid, equals(true));

    ref = Reference('Genesis', 60, 5, 60, 10);
    expect(ref.endVerse!.chapterNumber, equals(60));
    expect(ref.endVerse!.isValid, equals(false));
  });

  test(
      'Reference [start/end]Verse objects for (book and chapter) and chapter references',
      () {
    var ref = Reference('Ecclesiastes', 5);
    expect(ref.startVerse.verseNumber, equals(1));
    expect(ref.startVerse.chapterNumber, equals(5));
    expect(ref.endVerse!.verseNumber, equals(20));
    expect(ref.endVerse!.chapterNumber, equals(5));

    ref = Reference('Ecclesiastes');
    expect(ref.startVerse.verseNumber, equals(1));
    expect(ref.endVerse!.chapterNumber, equals(12));
    expect(ref.endVerse!.verseNumber, equals(14));
  });

  test('Reference [start/end]Chapter objects', () {
    var ref = Reference('Ecclesiastes', 5);
    expect(ref.startChapter.chapterNumber, equals(5));
    expect(ref.endChapter!.chapterNumber, equals(5));

    ref = Reference('Ecclesiastes');
    expect(ref.startChapter.chapterNumber, equals(1));
    expect(ref.endChapter!.chapterNumber, equals(12));
  });

  test('BibleReferences correctly returns osis, abbr, and short book names',
      () {
    var ref = Reference('Genesis', 2, 5);
    expect(ref.osisBook, equals('Gen'));
    expect(ref.abbrBook, equals('GEN'));
    expect(ref.shortBook, equals('Gn'));

    ref = Reference('Joseph', 2, 5);
    expect(ref.osisBook, equals(null));
    expect(ref.abbrBook, equals(null));
    expect(ref.shortBook, equals(null));
  });

  test('Retrieving osis, abbr, and short references', () {
    var ref = Reference('Genesis', 2, 5);
    expect(ref.osisReference, equals('Gen 2:5'));
    expect(ref.abbrReference, equals('GEN 2:5'));
    expect(ref.shortReference, equals('Gn 2:5'));

    ref = Reference('Joseph', 2, 5);
    expect(ref.osisReference, equals(null));
    expect(ref.abbrReference, equals(null));
    expect(ref.shortReference, equals(null));

    var chapter = Chapter('Matthew', 1);
    expect(chapter.osisReference, equals('Matt 1'));
    expect(chapter.abbrReference, equals('MAT 1'));
    expect(chapter.shortReference, equals('Mt 1'));

    var verse = Verse('Joel', 1, 2);
    expect(verse.osisReference, equals('Joel 1:2'));
    expect(verse.abbrReference, equals('JOE 1:2'));
    expect(verse.shortReference, equals('Jl 1:2'));
  });

  test('Retrieving subdivided references', () {
    var chapter = Chapter('Genesis', 2);
    var verses = chapter.verses!;
    expect(verses.length, equals(25));
    verses = chapter.verses!;
    expect(verses.length, equals(25), reason: 'Ensures verses are cached');

    var book = Reference('Genesis');
    var chapters = book.chapters!;
    expect(chapters.length, equals(50));
    chapters = book.chapters!;
    expect(chapters.length, equals(50), reason: 'Ensures chapters are cached');

    verses = book.verses!;
    expect(verses.length, equals(1533));

    var range = Reference('Genesis', 2, 3, 4, 5);
    verses = range.verses!;
    expect(verses.length, equals(52));

    var verse = Reference('Genesis', 2, 2);
    verses = verse.verses!;
    expect(verses.length, equals(1));
  });

  test('Redirective constructors', () {
    var chapter = Reference.chapter('Genesis', 2);
    expect(chapter.reference, equals('Genesis 2'));
    expect(chapter.referenceType, equals(ReferenceType.CHAPTER));

    var verse = Reference.verse('Genesis', 2, 2);
    expect(verse.reference, equals('Genesis 2:2'));
    expect(verse.referenceType, equals(ReferenceType.VERSE));

    var chapterRange = Reference.chapterRange('Genesis', 2, 3);
    expect(chapterRange.reference, equals('Genesis 2-3'));
    expect(chapterRange.referenceType, equals(ReferenceType.CHAPTER_RANGE));

    var verseRange = Reference.verseRange('Genesis', 2, 3, 4);
    expect(verseRange.referenceType, equals(ReferenceType.VERSE_RANGE));
  });
}
