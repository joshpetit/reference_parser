import 'package:reference_parser/src/model/Reference.dart';
import 'package:test/test.dart';

void main() {
  test('Creation of reference to a book', () {
    var ref = Reference('James');
    expect(ref.book, equals('James'));
    expect(ref.reference, equals('James'));
  });
  test('Creation of book and chapter reference', () {
    var ref = Reference('James', 5);
    expect(ref.reference, equals('James 5'));
    expect(ref.book, equals('James'));
    expect(ref.chapter, equals(5));
  });
  test('Creation of verse reference', () {
    var ref = Reference('James', 5, 2);
    expect(ref.reference, equals('James 5:2'));
    expect(ref.book, equals('James'));
    expect(ref.chapter, equals(5));
    expect(ref.startVerseNumber, equals(2));
  });
  test('Creation of verse reference', () {
    var ref = Reference('James', 5, 2, 3);
    expect(ref.reference, equals('James 5:2-3'));
    expect(ref.book, equals('James'));
    expect(ref.chapter, equals(5));
    expect(ref.startVerseNumber, equals(2));
    expect(ref.endVerseNumber, equals(3));
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
    expect(ref.bookNumber, equals(1), reason: 'Genesis is the 1st book_number');

    ref = Reference('John');
    expect(ref.bookNumber, equals(43), reason: 'John is the 43rd book_number');

    ref = Reference('Revelation');
    expect(ref.bookNumber, equals(66),
        reason: 'Revelation is the 66th book_number');

    ref = Reference('Joe');
    expect(ref.bookNumber, equals(null),
        reason: 'The Gospel of Joe does not exist');
  });
}
