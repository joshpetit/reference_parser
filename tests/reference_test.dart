import 'package:reference_parser/model/Reference.dart';
import 'package:test/test.dart';

void main() {
  test('Creation of reference to a book', () {
    var ref = Reference('James');
    expect(ref.book, equals('James'));
    expect(ref.reference, equals('James'));
  });
  test('Creation of book and chapter reference', () {
    var ref = Reference('James', chapter: 5);
    expect(ref.reference, equals('James 5'));
    expect(ref.book, equals('James'));
    expect(ref.chapter, equals(5));
  });
}
