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

  ///Validate that a book is in the bible (book name or OSIS format)
  static bool checkBook(String book) {
    book = book.toLowerCase();
    return BibleData.books.containsKey(book) ||
        BibleData.osis_books.containsKey(book);
  }

  ///Returns the osis, abbr, name, and short versions of a book title
  static Map<String, String> getBookNames(dynamic book) {
    if (book is String) {
      book = findBook(book);
    }
    if (!(book is int)) {
      return null;
    }
    var list = BibleData.book_names[book];
    return {
      'osis': list[0],
      'abbr': list[1],
      'name': list[2],
      'short': list[3]
    };
  }
}