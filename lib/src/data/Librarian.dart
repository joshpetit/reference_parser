import '../../reference_parser.dart';
import 'BibleData.dart';

/// A grouping of fields that parse strings and numbers
/// to create reference objects or return information
/// on certain bible properties.
///
/// Uses the [BibleData] class extensively.
class Librarian {
  ///Returns the book number from a string.
  static int? findBookNumber(String book) {
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

  /// Returns the osis, abbr, name, and short versions of a book title.
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

  /// Gets the last verse number in a specified book or book or chapter.
  static int? getLastVerseNumber(dynamic book, [int? chapter]) {
    if (book is String) {
      book = findBookNumber(book);
    }
    if (book is! int) {
      return null;
    }
    chapter ??= BibleData.lastVerse[book - 1].length;
    if (BibleData.lastVerse[book - 1].length < chapter || chapter < 1) {
      return null;
    }
    return BibleData.lastVerse[book - 1][chapter - 1];
  }

  /// Returns the number for the last chapter within a book.
  static int? getLastChapterNumber(dynamic book) {
    if (book is String) {
      book = findBookNumber(book);
    }
    if (book is! int) {
      return null;
    }
    if (book > BibleData.lastVerse.length) {
      return null;
    }
    return BibleData.lastVerse[book - 1].length;
  }

  /// Creates a [Verse] object for the last verse in a book or chapter.
  static Verse? getLastVerse(dynamic book, [int? chapter]) {
    int? bookNumber;
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

  /// Returns a [Chapter] object that corresponds to the
  /// last chapter within a book.
  static Chapter? getLastChapter(dynamic book) {
    int? bookNumber;
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
    if (BibleData.lastVerse.length < bookNumber) {
      return null;
    }
    var bookNames = getBookNames(book);
    book = bookNames['name'];
    var chapter = BibleData.lastVerse[bookNumber - 1].length;

    return Chapter(book, chapter);
  }

  /// Returns the [ReferenceType] based on the number of passed in arguments.
  static ReferenceType? identifyReferenceType(book,
      [startChapter, startVerse, endChapter, endVerse]) {
    if (startChapter == null && endChapter == null) {
      return ReferenceType.BOOK;
    } else if (startChapter != null &&
        endChapter != null &&
        startChapter != endChapter) {
      return ReferenceType.CHAPTER_RANGE;
    } else if (startChapter != null &&
        (endChapter == null || endChapter == startChapter) &&
        startVerse == null &&
        endVerse == null) {
      return ReferenceType.CHAPTER;
    } else if (startVerse != null && endVerse != null) {
      return ReferenceType.VERSE_RANGE;
    } else if (startVerse != null) {
      return ReferenceType.VERSE;
    }
    return null;
  }

  /// Verifies a reference based on which fields are left `null`
  /// or can be found within the bible.
  static bool verifyReference(dynamic book,
      [int? startChapter, int? startVerse, endChapter, endVerse]) {
    if (book == null) {
      return false;
    }
    if (book is String) {
      book = findBookNumber(book);
    }
    if (book is! int) return false;

    if (!(book > 0 && BibleData.lastVerse.length >= book)) {
      return false;
    }

    if (startChapter != null) {
      if (!(startChapter > 0 &&
          BibleData.lastVerse[book - 1].length >= startChapter)) {
        return false;
      }
      if (endChapter != null && startChapter > endChapter) {
        return false;
      }
    } else if (endChapter != null || endVerse != null) {
      return false;
    }

    if (startVerse != null) {
      if (!(startVerse > 0 &&
          BibleData.lastVerse[book - 1][startChapter! - 1] >= startVerse)) {
        return false;
      }
      if (endVerse != null && startVerse > endVerse) {
        return false;
      }
    }

    if (endChapter != null) {
      if (!(BibleData.lastVerse[book - 1].length >= endChapter)) {
        return false;
      }
    }

    endChapter ??= startChapter;
    if (endVerse != null) {
      if (endChapter == null) {
        return false;
      }
      if (endChapter == null && startVerse == null) {
        return false;
      } else if (startVerse != null && endVerse < startVerse) {
        return false;
      } else if (!(endVerse > 0 &&
          BibleData.lastVerse[book - 1][endChapter - 1] >= endVerse)) {
        return false;
      }
    }
    return true;
  }

  /// Creates a String reference based on which fields are left `null`.
  ///
  /// Does not validate references beyond checkin to see if the book
  /// field is left null. In cases where the book field is left null
  /// a `null` value will be returned.
  static String? createReferenceString(String? book,
      [int? startChapter, int? startVerse, int? endChapter, int? endVerse]) {
    if (book == null) return null;
    var reference = StringBuffer(book);
    if (startChapter != null) {
      reference.write(' $startChapter');
      if (startVerse != null) {
        reference.write(':$startVerse');
        if (endChapter != null && endChapter != startChapter) {
          reference.write(' - $endChapter');
          reference
              .write(':${endVerse ?? getLastVerseNumber(endChapter) ?? 1}');
        } else if (endVerse != null && endVerse != startVerse) {
          reference.write('-$endVerse');
        }
      } else if (endChapter != null && endChapter != startChapter) {
        if (endVerse != null) {
          reference.write(':1 - $endChapter:$endVerse');
        } else {
          reference.write('-$endChapter');
        }
      }
    }
    return reference.toString();
  }
}
