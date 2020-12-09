import 'package:reference_parser/src/model/Reference.dart';
import 'package:reference_parser/src/model/Verse.dart';
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
    expect(ref.startChapterNumber, equals(null));
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
    var ref = Reference('James', 5, 2, 3);
    expect(ref.reference, equals('James 5:2-3'));
    expect(ref.book, equals('James'));
    expect(ref.startChapterNumber, equals(5));
    expect(ref.startVerseNumber, equals(2));
    expect(ref.endVerseNumber, equals(3));
    expect(ref.referenceType, equals(ReferenceType.RANGE));
  });
  test('Verification works correctly', () {
    var ref = Reference('James', 2, 4);
    expect(ref.isValid, equals(true), reason: 'Passage should be valid');

    ref = Reference('James', 15, 5, 3);
    expect(ref.isValid, equals(false), reason: 'Chapter should not be valid');

    ref = Reference('James', 15, -5, 3);
    expect(ref.isValid, equals(false),
        reason: 'Negative values should return false');

    ref = Reference('Psalms', 1, 5, 100);
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
    expect(verse.chapter, equals(2));
    expect(verse.bookNumber, equals(1));
    expect(verse.verseNumber, equals(3));
    expect(verse.reference, equals('Genesis 2:3'));
    expect(verse.isValid, equals(true));
  });
  test('Reference [start/end]Verse objects for single verse references', () {
    var ref = Reference('John', 2, 4);
    expect(ref.endVerse.verseNumber, ref.startVerse.verseNumber,
        reason: 'This is a single verse Reference');

    expect(ref.startVerse.book, equals('John'),
        reason: 'All verses have a book');

    expect(ref.startVerse.chapter, equals(2),
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
    var ref = Reference('Genesis', 2, 5, 10);
    expect(ref.endVerse.book, equals('Genesis'));
    expect(ref.endVerse.verseNumber, equals(10));
    expect(ref.endVerse.chapter, equals(2));
    expect(ref.endVerse.isValid, equals(true));

    ref = Reference('Genesis', 60, 5, 10);
    expect(ref.endVerse.chapter, equals(60));
    expect(ref.endVerse.isValid, equals(false));
  });
  test(
      'Reference [start/end]Verse objects for (book and chapter) and chapter references',
      () {
    var ref = Reference('Ecclesiastes', 5);
    expect(ref.startVerse.verseNumber, equals(1));
    expect(ref.startVerse.chapter, equals(5));
    expect(ref.endVerse.verseNumber, equals(20));
    expect(ref.endVerse.chapter, equals(5));

    ref = Reference('Ecclesiastes');
    expect(ref.startVerse.verseNumber, equals(1));
    expect(ref.endVerse.chapter, equals(12));
    expect(ref.endVerse.verseNumber, equals(14));
  });
  test('BibleReferences correctly returns osis, abbr, and short book names',
      () {
    var ref = Reference('Genesis', 2, 5, 10);
    expect(ref.osis, equals('Gen'));
    expect(ref.abbr, equals('GEN'));
    expect(ref.short, equals('Gn'));

    ref = Reference('Joseph', 2, 5, 10);
    expect(ref.osis, equals(null));
    expect(ref.abbr, equals(null));
    expect(ref.short, equals(null));
  });
}
