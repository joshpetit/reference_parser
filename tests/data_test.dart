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
  });
}
