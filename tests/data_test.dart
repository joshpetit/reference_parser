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
}