
import 'BibleData.dart';

class Librarian {
  ///Returns the integer of the book, checks for variant spellings also
  static int findBook(String book) {
    book = book.toLowerCase();
    var val = BibleData.books[book];
    if (val != null) {
      return val;
    }
    val = BibleData.osisBooks[book];
    if (val != null) {
      return val;
    }
    val = BibleData.shortenedBooks[book];
    if (val != null) {
      return val;
    }
    return BibleData.variants[book];
  }

  ///Validate that a book is in the bible (book name or OSIS format)
  static bool checkBook(String book) {
    book = book.toLowerCase();
    return BibleData.books.containsKey(book) ||
        BibleData.osisBooks.containsKey(book) ||
    BibleData.shortenedBooks.containsKey(book);
  }

  ///Returns the osis, abbr, name, and short versions of a book title
  static Map<String, String> getBookNames(dynamic book) {
    if (book is String) {
      book = findBook(book);
    }
    if (!(book is int)) {
      return {};
    }
    var list = BibleData.bookNames[book - 1];
    return {
      'osis': list[0],
      'abbr': list[1],
      'name': list[2],
      'short': list[3]
    };
  }

  static bool verifyVerse(dynamic book, [int chapter, int verse]) {
    if (book is String) {
      book = findBook(book);
    }
    if (!(book is int)) return false;

    if (!(book > 0 && BibleData.lastVerse.length >= book)) {
      return false;
    } else if (chapter != null &&
        !(chapter > 0 && BibleData.lastVerse[book - 1].length >= chapter)) {
      return false;
    } else if (verse != null &&
        !(verse > 0 && BibleData.lastVerse[book - 1][chapter - 1] >= verse)) {
      return false;
    }
    return true;
  }

  ///Creates a *String* reference from a book and optional chapter and verses
  static String createReferenceString(String book,
      [int chapter, int startVerse, int endVerse]) {
    var reference = '' + book;
    if (chapter != null) {
      reference += ' ${chapter}';
      if (startVerse != null) {
        reference += ':${startVerse}';
        if (endVerse != null) {
          reference += '-$endVerse';
        }
      }
    }
    return reference;
  }
}
