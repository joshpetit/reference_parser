import '../../reference_parser.dart';
import 'package:reference_parser/src/model/Verse.dart';
import 'BibleData.dart';

class Librarian {
  ///Returns the book number from a string.
  static int findBookNumber(String book) {
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

  ///Validate that a book is in the bible, does not validate mispellings.
  static bool checkBook(String book) {
    book = book.toLowerCase();
    return BibleData.books.containsKey(book) ||
        BibleData.osisBooks.containsKey(book) ||
        BibleData.shortenedBooks.containsKey(book);
  }

  ///Returns the osis, abbr, name, and short versions of a book title.
  static Map<String, String> getBookNames(dynamic book) {
    if (book is String) {
      book = findBookNumber(book);
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

  /// Gets the last verse number in a specified book or book + chapter.
  static int getLastVerseNumber(dynamic book, [int chapter]) {
    if (book is String) {
      book = findBookNumber(book);
    }
    if (book is! int) {
      return null;
    }
    chapter ??= BibleData.lastVerse[book - 1].length;
    return BibleData.lastVerse[book - 1][chapter - 1];
  }

  static int getLastChapterNumber(dynamic book) {
    if (book is String) {
      book = findBookNumber(book);
    }
    if (book is! int) {
      return null;
    }
    return BibleData.lastVerse[book - 1].length;
  }

  /// Creates a verse object for the last verse in a book or book + chapter.
  static Verse getLastVerse(dynamic book, [int chapter]) {
    int bookNumber;
    if (book is int) {
      bookNumber = book;
    } else if (book is String) {
      bookNumber = findBookNumber(book);
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

  /// Returns the type of reference based on the number of passed in arguments.
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

  /// Verifies that a book, and optionally chapter and verse, are in the bible.
  static bool verifyVerse(dynamic book, [int chapter, int verse]) {
    if (book is String) {
      book = findBookNumber(book);
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
    } else if (verse != null &&
        !(verse > 0 && BibleData.lastVerse[book - 1][chapter - 1] >= verse)) {
      return false;
    }
    return true;
  }

  ///Creates a String reference from a book and optionallly chapter and verses.
  static String createReferenceString(String book,
      [int startChapter, int startVerse, int endChapter, int endVerse]) {
    var reference = '' + book;
    if (startChapter != null) {
      reference += ' ${startChapter}';
      if (startVerse != null) {
        reference += ':${startVerse}';
        if (endChapter != null && endChapter != startChapter) {
          reference += ' - ${endChapter}';
          reference += ':${endVerse ?? getLastVerseNumber(endChapter) ?? 1}';
        } else if (endVerse != null) {
          reference += '-${endVerse}';
        }
      } else if (endChapter != null) {
        reference += '-${endChapter}';
      }
    }
    return reference;
  }
}
