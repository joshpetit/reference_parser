import 'package:reference_parser/src/util/VerseEnum.dart';
import 'package:reference_parser/src/data/Librarian.dart';

/// Base class for all reference objects
abstract class BibleReference {
  /// The representation of the reference.
  final String reference;

  /// The whole book name of the reference.
  ///
  /// Returns `null` if the book name could not be parsed.
  final String book;

  /// The different reference formats for book names.
  /// Access values by using getters.
  final Map<String, String> _bookNames;

  /// The book number for the passed in reference book.
  ///
  /// Returns `null` if the book name is null or invalid.
  final int bookNumber;

  /// The type of reference.
  final ReferenceType referenceType;

  /// Whether the reference is in the bible.
  final bool isValid;

  BibleReference(book)
      : book = book,
        reference = Librarian.createReferenceString(book),
        bookNumber = Librarian.findBookNumber(book),
        referenceType = Librarian.identifyReferenceType(book),
        _bookNames = Librarian.getBookNames(book),
        isValid = Librarian.verifyVerse(book);

  /// Returns [BibleReference.reference]
  @override
  String toString() {
    return reference;
  }

  /// The title cased representation of the reference's book.
  String get osis => _bookNames['osis'];

  /// The uppercased letter paratext abbreviation of the reference's book.
  String get abbr => _bookNames['abbr'];

  /// The shortest abbreviation for the reference's book.
  String get short => _bookNames['short'];
}
