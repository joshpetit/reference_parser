import 'package:reference_parser/src/data/Librarian.dart';
import 'package:reference_parser/src/model/Verse.dart';

import 'package:reference_parser/src/util/VerseEnum.dart';

class Reference {
  final String reference;
  final String book;
  final int bookNumber;
  final int chapter;
  final int startVerseNumber;
  final int endVerseNumber;
  final bool isValid;

  Reference(book, [chapter, startVerseNumber, endVerseNumber])
      : book = book,
        chapter = chapter,
        startVerseNumber = startVerseNumber,
        endVerseNumber = endVerseNumber,
        bookNumber = Librarian.findBook(book),
        reference = Librarian.createReferenceString(
            book, chapter, startVerseNumber, endVerseNumber),
        isValid = Librarian.verifyVerse(book, chapter, startVerseNumber) &&
            Librarian.verifyVerse(book, chapter, endVerseNumber);
  @override
  String toString() {
    return reference;
  }
}
