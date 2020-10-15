import 'package:reference_parser/src/data/Librarian.dart';
import 'package:test/test.dart';

void main() {
  test('Retrieves correct book number', () {
    //test full book name
    var bookNumber = Librarian.findBook('genesis');
    expect(bookNumber, 1);
    //test osis book name
    bookNumber = Librarian.findBook('1cor');
    expect(bookNumber, 46);
    //test variant book name
    bookNumber = Librarian.findBook('psalm');
    expect(bookNumber, 19);
  });
  test('Returns null for nonexistent books', () {
    var bookNumber = Librarian.findBook('joe');
    expect(bookNumber, null);
  });
  test('Librarian checks book validity correctly', () {
    expect(Librarian.checkBook('joe'), false);
    expect(Librarian.checkBook('1cor'), true);
    expect(Librarian.checkBook('Genesis'), true);
    expect(Librarian.checkBook('jn'), true);
  });
  test('Librarian returns correct book names', () {
    var names = Librarian.getBookNames(1);
    expect(names['osis'], 'Gen');
    expect(names['abbr'], 'GEN');
    expect(names['name'], 'Genesis');
    expect(names['short'], 'Gn');

    names = Librarian.getBookNames('1 Corinthians');
    expect(names['osis'], '1Cor');
    expect(names['abbr'], '1CO');
    expect(names['name'], '1 Corinthians');
    expect(names['short'], '1 Cor');

    names = Librarian.getBookNames('');
    expect(names.length, equals(0));
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

    expect(Librarian.verifyVerse('John', 1, 1), true,
        reason: 'String book references should work');
  });
  test('Librarian correctly fetches last verses', () {
    expect(Librarian.getLastVerse('John'), equals(25));
  });
}
