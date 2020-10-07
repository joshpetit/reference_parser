import 'package:reference_parser/data/Librarian.dart';

class Reference {
  final String reference;
  final String book;
  final int bookNumber;
  final int chapter;
  final int startVerse;
  final int endVerse;
  final bool isValid;

  Reference(book, [chapter, startVerse, endVerse])
      : book = book,
        chapter = chapter,
        startVerse = startVerse,
        endVerse = endVerse,
        bookNumber = Librarian.findBook(book),
        reference =
            Librarian.createReference(book, chapter, startVerse, endVerse),
        isValid = Librarian.verifyVerse(book, chapter, startVerse);
}
