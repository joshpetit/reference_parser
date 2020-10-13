import 'package:reference_parser/reference_parser.dart';
import 'package:test/test.dart';

void main() {
  test('Creation of reference from parser', () {
    var ref = parseReference('John 3:16');
    expect(ref.book, equals('John'));
    expect(ref.chapter, equals(3));
    expect(ref.reference, equals('John 3:16'));
    expect(ref.startVerse, equals(16));

    ref = parseReference('1john 3:16');
    expect(ref.book, equals('1 John'));
    expect(ref.chapter, equals(3));
    expect(ref.reference, equals('1 John 3:16'));
    expect(ref.startVerse, equals(16));

    ref = parseReference('Joe 2:4');
    expect(ref.book, equals('Joe'));
    expect(ref.isValid, false);

    ref = parseReference('Jn 2:4');
    expect(ref.book, equals('John'));
    expect(ref.book, 'John');
    expect(ref.chapter, 2);
    expect(ref.startVerse, 4);
    expect(ref.isValid, true);

    ref = parseReference('');
    expect(ref.book, '');
    expect(ref.isValid, false);
  });

  test('Creation of reference from createReference', () {
    var ref = createReference('James', 2, 1);
    expect(ref.book, equals('James'));
    expect(ref.chapter, equals(2));
    expect(ref.startVerse, equals(1));

    ref = createReference('JOHN', 2, 1);
    expect(ref.book, equals('John'));
    expect(ref.startVerse, equals(1));
  });
}
