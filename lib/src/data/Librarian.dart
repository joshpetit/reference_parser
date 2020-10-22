import '../../reference_parser.dart';
import 'package:reference_parser/src/model/Verse.dart';
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
    if (book is! int) {
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

  static int getLastVerseNumber(dynamic book, [int chapter]) {
    if (book is String) {
      book = findBook(book);
    }
    if (book is! int) {
      return null;
    }
    chapter ??= BibleData.lastVerse[book - 1].length;
    return BibleData.lastVerse[book - 1][chapter - 1];
  }

  static Verse getLastVerse(dynamic book, [int chapter]) {
    int bookNumber;
    if (book is int) {
      bookNumber = book;
    } else if (book is String) {
      bookNumber = findBook(book);
    } else {
      return null;
    }
    if (bookNumber == null) {
      return null;
    }
    var bookNames = getBookNames(book);
    book = bookNames['name'];
    chapter ??= BibleData.lastVerse[bookNumber - 1].length;
    if (BibleData.lastVerse[bookNumber - 1].length < chapter || chapter < 1) {
      return null;
    }
    var lastVerse = BibleData.lastVerse[bookNumber - 1][chapter - 1];
    return Verse(book, chapter, lastVerse);
  }

  static ReferenceType identifyReferenceType(book,
      [chapter, startVerse, endVerse]) {
    if (endVerse != null) {
      return ReferenceType.RANGE;
    } else if (startVerse != null) {
      return ReferenceType.VERSE;
    } else if (chapter != null) {
      return ReferenceType.CHAPTER;
    } else {
      return ReferenceType.BOOK;
    }
  }

  ///Verifies that a verse is in the bible, optional chapter and verse
  ///positional parameters
  static bool verifyVerse(dynamic book, [int chapter, int verse]) {
    if (book is String) {
      book = findBook(book);
    }
    if (book is! int) return false;

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
