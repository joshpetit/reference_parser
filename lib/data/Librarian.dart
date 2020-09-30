import 'package:reference_parser/data/BibleData.dart';

class Librarian {
  static int findBook(String book) {
    return BibleData.books[book];
  }
  static bool checkBook(String book) {
    return BibleData.books.containsKey(book);
  }
}