import 'package:reference_parser/data/BibleData.dart';

class Librarian {
  ///Returns the integer of the book, checks for variant spellings also
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
   return BibleData.variants[book];
  }
  static bool checkBook(String book) {
    book = book.toLowerCase();
    return BibleData.books.containsKey(book) ||
        BibleData.osis_books.containsKey(book);
  }
}