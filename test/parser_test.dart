import 'package:reference_parser/reference_parser.dart';
import 'package:test/test.dart';

void main() {
  test('Creation of reference from parser', () {
    var ref = parseReference('John 3:16');
    expect(ref.book, equals('John'));
    expect(ref.chapter, equals(3));
    expect(ref.reference, equals('John 3:16'));
    expect(ref.startVerseNumber, equals(16));

    ref = parseReference('1john 3:16');
    expect(ref.book, equals('1 John'));
    expect(ref.chapter, equals(3));
    expect(ref.reference, equals('1 John 3:16'));
    expect(ref.startVerseNumber, equals(16));

    ref = parseReference('Jn 2:4');
    expect(ref.book, equals('John'));
    expect(ref.book, 'John');
    expect(ref.chapter, 2);
    expect(ref.startVerseNumber, 4);
    expect(ref.isValid, true);

    ref = parseReference('');
    expect(ref.book, '');
    expect(ref.isValid, false);

    ref = parseReference('I love John 4:5-10');
    expect(ref.book, equals('John'));
    expect(ref.chapter, equals(4));
    expect(ref.startVerseNumber, equals(5));
    expect(ref.endVerseNumber, equals(10));

    ref = parseReference('This is going to parse Isaiah');
    expect(ref.book, equals('Isaiah'), reason: '\'is\' is parsed first');

    ref = parseReference('Only jam should be parsed');
    print(ref.reference);
    expect(ref.book, equals('James'));

    // I guess the Gospel of Joe does exist!
    //
    // TODO: Add paratext abbreviations to parsed books, filter out
    // paratexts that are found in OSIS references.
    //ref = parseReference('Joe 4:5-10');
    //expect(ref.book, equals(''));
    //expect(ref.isValid, equals(false));
  });
}
