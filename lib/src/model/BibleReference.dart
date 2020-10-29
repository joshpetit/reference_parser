import 'package:reference_parser/src/util/VerseEnum.dart';
import 'package:reference_parser/src/data/Librarian.dart';

/// Base class for all reference objects, basically a [ReferenceType.BOOK].
abstract class BibleReference {
  /// The representation of the reference.
  final String reference;

  /// The full book name of the reference.
  ///
  /// Can be an invalid book reference, always.
  /// check [isValid] to verify the reference's
  /// authenticity.
  final String book;

  /// The different reference formats for book names.
  /// Access values by using getters.
  final Map<String, String> _bookNames;

  /// The book number for the passed in reference book.
  ///
  /// `null` if the book name is null or invalid.
  final int bookNumber;

  /// The type of reference.
  final ReferenceType referenceType;

  /// Whether the reference is in the bible.
  final bool isValid;

  /// Constructs the [BibleReference] as a reference to a book.
  BibleReference(book)
      : book = Librarian.getBookNames(book)['name'] ?? book,
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

  /// The title cased representation for this reference's book.
  String get osis => _bookNames['osis'];

  /// The uppercased paratext abbreviation for this reference's book.
  String get abbr => _bookNames['abbr'];

  /// The shortest standard abbreviation for this reference's book.
  String get short => _bookNames['short'];
}
