import 'package:reference_parser/data/Librarian.dart';
import 'package:test/test.dart';

void main() {
  test('Retrieves correct book number', () {
    //test full book name
    var bookNumber = Librarian.findBook('genesis');
    expect(1, bookNumber);
    //test osis book name
    bookNumber = Librarian.findBook('1cor');
    expect(46, bookNumber);
    //test variant book name
    bookNumber = Librarian.findBook('psalm');
    expect(19, bookNumber);
  });
  test('Returns null for nonexistent books', () {
    var bookNumber = Librarian.findBook('joe');
    expect(null, bookNumber);
  });
  test('Librarian checks book validity correctly', () {
    expect(false, Librarian.checkBook('joe'));
    expect(true, Librarian.checkBook('1cor'));
    expect(true, Librarian.checkBook('Genesis'));
  });
  test('Librarian returns correct book names', () {
    var names = Librarian.getBookNames(1);
    expect('Gen', names['osis']);
    expect('GEN', names['abbr']);
    expect('Genesis', names['name']);
    expect('Gn', names['short']);

    names = Librarian.getBookNames('1 Corinthians');
    expect('1Cor', names['osis']);
    expect('1CO', names['abbr']);
    expect('1 Corinthians', names['name']);
    expect('1 Cor', names['short']);
  });
  test('Librarian correctly verifies verses', () {
    expect(Librarian.verifyVerse(1), true, reason: 'First book should exist');
    expect(Librarian.verifyVerse(33), true, reason: 'Middle book should exist');
    expect(Librarian.verifyVerse(66), true, reason: 'Last book should exist');
    expect(Librarian.verifyVerse(67), false,
        reason: '67th book does not exist');
    expect(Librarian.verifyVerse(-1), false,
        reason: 'Negative books do not exist');

    expect(Librarian.verifyVerse(33, 1), true,
        reason: 'Book and chapter should exist');

    expect(Librarian.verifyVerse(33, 8), false,
        reason: 'Book and chapter should not exist');

    expect(Librarian.verifyVerse(33, 1, 1), true,
        reason: 'Book, chapter, and verse should exist');

    expect(Librarian.verifyVerse(33, 1, 16), true,
        reason: 'Book, chapter, and ending verse should exist');

    expect(Librarian.verifyVerse(33, 1, 17), false,
        reason: 'Verse should not exist');
  });
}
