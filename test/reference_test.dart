import 'package:reference_parser/src/model/Reference.dart';
import 'package:reference_parser/src/model/Verse.dart';
import 'package:reference_parser/src/util/VerseEnum.dart';
import 'package:test/test.dart';

void main() {
  test('Creation of reference to a book', () {
    var ref = Reference('James');
    expect(ref.book, equals('James'));
    expect(ref.reference, equals('James'));
    expect(ref.referenceType, equals(ReferenceType.BOOK));
  });
  test('Creation of book and chapter reference', () {
    var ref = Reference('James', 5);
    expect(ref.reference, equals('James 5'));
    expect(ref.book, equals('James'));
    expect(ref.chapter, equals(5));
    expect(ref.referenceType, equals(ReferenceType.CHAPTER));
  });
  test('Creation of verse reference', () {
    var ref = Reference('James', 5, 2);
    expect(ref.reference, equals('James 5:2'));
    expect(ref.book, equals('James'));
    expect(ref.chapter, equals(5));
    expect(ref.startVerseNumber, equals(2));
    expect(ref.referenceType, equals(ReferenceType.VERSE));
  });
  test('Creation of range of verses reference', () {
    var ref = Reference('James', 5, 2, 3);
    expect(ref.reference, equals('James 5:2-3'));
    expect(ref.book, equals('James'));
    expect(ref.chapter, equals(5));
    expect(ref.startVerseNumber, equals(2));
    expect(ref.endVerseNumber, equals(3));
    expect(ref.referenceType, equals(ReferenceType.RANGE));
  });
  test('Verification works correctly', () {
    var ref = Reference('James', 2, 4);
    expect(ref.isValid, true, reason: 'Passage should be valid');
    ref = Reference('James', 15, 5, 3);
    expect(ref.isValid, false, reason: 'Chapter should not be valid');
    ref = Reference('James', 15, -5, 3);
    expect(ref.isValid, false, reason: 'Negative values should return false');
    ref = Reference('Psalms', 1, 5, 100);
    expect(ref.isValid, false, reason: 'End verse should not be valid');
  });
  test('Book numbers correctly initialized', () {
    var ref = Reference('Genesis');
    expect(ref.bookNumber, equals(1), reason: 'Genesis is the 1st book');

    ref = Reference('John');
    expect(ref.bookNumber, equals(43), reason: 'John is the 43rd book');

    ref = Reference('Revelation');
    expect(ref.bookNumber, equals(66), reason: 'Revelation is the 66th book');

    ref = Reference('Joe');
    expect(ref.bookNumber, equals(null),
        reason: 'The Gospel of Joe does not exist');
  });
  test('Verse object creation', () {
    var verse = Verse('Genesis', 2, 3);
    expect(verse.book, equals('Genesis'));
    expect(verse.chapter, equals(2));
    expect(verse.bookNumber, equals(1));
    expect(verse.verseNumber, equals(3));
    expect(verse.isValid, equals(true));
  });
}
