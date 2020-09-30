import 'package:reference_parser/data/BibleData.dart';

class Librarian {
  static int findBook(String book) {
    book = book.toLowerCase();
    var val = BibleData.books[book];
    if (val != null) {
      return val;
    }
    val = BibleData.osis_books[book];
    if (val != null) {
      return val;
    }
    return BibleData.books[book.toLowerCase()];
  }
  static bool checkBook(String book) {
    return BibleData.books.containsKey(book) ||
        BibleData.osis_books.containsKey(book);
  }
}