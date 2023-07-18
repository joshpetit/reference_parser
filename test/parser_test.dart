import 'package:reference_parser/reference_parser.dart';
import 'package:reference_parser/identification.dart';
import 'package:test/test.dart';

void main() {
  test('Creation of reference from parser', () {
    var ref = parseReference('John 3:16');
    expect(ref.reference, equals('John 3:16'));
    expect(ref.book, equals('John'));
    expect(ref.startChapterNumber, equals(3));
    expect(ref.startVerseNumber, equals(16));

    ref = parseReference('1john 3:16');
    expect(ref.reference, equals('1 John 3:16'));
    expect(ref.book, equals('1 John'));
    expect(ref.startChapterNumber, equals(3));
    expect(ref.reference, equals('1 John 3:16'));
    expect(ref.startVerseNumber, equals(16));

    ref = parseReference('Jn 2:4');
    expect(ref.reference, equals('John 2:4'));
    expect(ref.book, equals('John'));
    expect(ref.book, 'John');
    expect(ref.startChapterNumber, 2);
    expect(ref.startVerseNumber, 4);
    expect(ref.isValid, true);

    ref = parseReference('');
    expect(ref.book, '');
    expect(ref.isValid, false);

    ref = parseReference('I love John 4:5-10');
    expect(ref.reference, equals('John 4:5-10'));
    expect(ref.book, equals('John'));
    expect(ref.startChapterNumber, equals(4));
    expect(ref.startVerseNumber, equals(5));
    expect(ref.endVerseNumber, equals(10));

    ref = parseReference('This is not going to parse Matthew');
    expect(ref.book, equals('Isaiah'), reason: '\'is\' is parsed first');

    ref = parseReference('Only jam should be parsed');
    expect(ref.book, equals('James'));

    ref = parseReference('Joe 2:5-10');
    expect(ref.reference, equals('Joel 2:5-10'));
    expect(ref.book, equals('Joel'));
    expect(ref.isValid, equals(true));

    ref = parseReference('Joseph 5:10-11');
    expect(ref.isValid, equals(false));
    expect(ref.book, equals(''));

    ref = parseReference('So what about James 1 - 2');
    expect(ref.reference, equals('James 1-2'));
    expect(ref.book, equals('James'));
    expect(ref.startChapterNumber, 1);
    expect(ref.endChapterNumber, 2);
    expect(ref.isValid, true);

    ref = parseReference('James 1.2');
    expect(ref.book, equals('James'));
    expect(ref.reference, equals('James 1:2'));
    expect(ref.isValid, true);

    ref = parseReference('James 1.2 -  2');
    expect(ref.book, equals('James'));
    expect(ref.reference, equals('James 1:2'));
    expect(ref.isValid, true);

    // The ~em~ dash
    ref = parseReference('James 1—2');
    expect(ref.reference, equals('James 1-2'));
    expect(ref.book, equals('James'));
    expect(ref.isValid, true);

    ref = parseReference('James 1.2 -  2:4');
    expect(ref.reference, equals('James 1:2 - 2:4'));
    expect(ref.book, equals('James'));
    expect(ref.isValid, true);

    ref = parseReference('James 1 . 2 -  2 . 4');
    expect(ref.reference, equals('James 1:2 - 2:4'));
    expect(ref.book, equals('James'));
    expect(ref.isValid, true);

    ref = parseReference('Genesis 3');
    expect(ref.reference, equals('Genesis 3'));
    expect(ref.endVerseNumber, equals(24));
    expect(ref.isValid, true);

    ref = parseReference('Matthew 2:3-5 - 5:7');
    expect(ref.reference, equals('Matthew 2:3-5'));
  });

  test('Allow parsing books with roman numerals', () {
    var ref = parseReference('I corinthians');
    expect(ref.reference, equals('1 Corinthians'));
  });

  test('Allow parsing numbered books without spaces', () {
    var ref = parseReference('1corinthians 1:23');
    expect(ref.reference, equals('1 Corinthians 1:23'));
  });

  test('Parsing all references', () {
    var refs = parseAllReferences('I hope Matt 2:4 and James 5:1-5 get parsed');
    expect(refs.length, equals(2));
    var mat = refs[0];
    var jam = refs[1];
    expect(mat.book, equals('Matthew'));
    expect(mat.startChapterNumber, equals(2));
    expect(mat.startVerseNumber, equals(4));

    refs = parseAllReferences('is is still parsed');
    expect(refs.length, equals(2));

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

  test('Reference identification', () {
    var refs = identifyReference('Come to me all ye');
    refs.then((x) => {
          expect(x.length, greaterThan(3)),
        });
  });
}
