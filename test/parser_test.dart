import 'package:reference_parser/reference_parser.dart';
import 'package:test/test.dart';

void main() {
  test('Creation of reference from parser', () {
    var ref = parseReference('John 3:16');
    expect(ref.book, equals('John'));
    expect(ref.startChapterNumber, equals(3));
    expect(ref.reference, equals('John 3:16'));
    expect(ref.startVerseNumber, equals(16));

    ref = parseReference('1john 3:16');
    expect(ref.book, equals('1 John'));
    expect(ref.startChapterNumber, equals(3));
    expect(ref.reference, equals('1 John 3:16'));
    expect(ref.startVerseNumber, equals(16));

    ref = parseReference('Jn 2:4');
    expect(ref.book, equals('John'));
    expect(ref.book, 'John');
    expect(ref.startChapterNumber, 2);
    expect(ref.startVerseNumber, 4);
    expect(ref.isValid, true);

    ref = parseReference('');
    expect(ref.book, '');
    expect(ref.isValid, false);

    ref = parseReference('I love John 4:5-10');
    expect(ref.book, equals('John'));
    expect(ref.startChapterNumber, equals(4));
    expect(ref.startVerseNumber, equals(5));
    expect(ref.endVerseNumber, equals(10));

    ref = parseReference('This is going to parse Isaiah');
    expect(ref.book, equals('Isaiah'), reason: '\'is\' is parsed first');

    ref = parseReference('Only jam should be parsed');
    expect(ref.book, equals('James'));

    ref = parseReference('Joe 2:5-10');
    expect(ref.book, equals('Joel'));
    expect(ref.isValid, equals(true));

    ref = parseReference('Joseph 5:10-11');
    expect(ref.isValid, equals(false));
    expect(ref.book, equals(''));
  });
  test('Parsing all references', () {
    var refs = parseAllReferences('I hope Matt 2:4 and James 5:1-5 get parsed');
    expect(refs.length, equals(2));
    var mat = refs[0];
    var jam = refs[1];
    expect(mat.book, equals('Matthew'));
    expect(mat.startChapterNumber, equals(2));
    expect(mat.startVerseNumber, equals(4));

    expect(jam.book, equals('James'));
    expect(jam.startChapterNumber, equals(5));
    expect(jam.startVerseNumber, equals(1));
    expect(jam.endVerseNumber, equals(5));

    refs = parseAllReferences('This contains nothing');
    expect(refs.length, equals(0),
        reason: 'This string contains no references');
  });
  test('Verify paratexts', () {
    var refs = parseAllReferences('Mat Jam PSA joh');
    refs.forEach((x) {
      expect(x.book.length, greaterThan(3),
          reason: 'Paratexts should be parsed');
    });
  });
  test('capabilities', () {
    var ref = parseReference('Mat 2-3');
    print(ref);
  });
}
