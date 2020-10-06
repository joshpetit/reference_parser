import 'dart:io';

import 'package:reference_parser/model/Reference.dart';
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
    expect(ref.start_verse, equals(2));
  });
  test('Creation of verse reference', () {
    var ref = Reference('James', 5, 2, 3);
    expect(ref.reference, equals('James 5:2-3'));
    expect(ref.book, equals('James'));
    expect(ref.chapter, equals(5));
    expect(ref.start_verse, equals(2));
    expect(ref.end_verse, equals(3));
  });
  test('Verification works correctly', () {
    var ref = Reference('James', 2, 4);
    expect(ref.is_valid, true, reason: 'Passage should be valid');
    ref = Reference('James', 15, 5, 3);
    expect(ref.is_valid, false, reason: 'Passage should not be valid');
  });
  test('Book numbers correctly initialized', () {
    var ref = Reference('Genesis');
    expect(ref.book_number, equals(1),
        reason: 'Genesis is the 1st book_number');

    ref = Reference('John');
    expect(ref.book_number, equals(43), reason: 'John is the 43rd book_number');

    ref = Reference('Revelation');
    expect(ref.book_number, equals(66),
        reason: 'Revelation is the 66th book_number');

    ref = Reference('Joe');
    expect(ref.book_number, equals(null),
        reason: 'The Gospel of Joe does not exist');
  });
}
