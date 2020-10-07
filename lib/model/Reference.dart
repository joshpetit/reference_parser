import 'package:reference_parser/data/Librarian.dart';

class Reference {
  final String reference;
  final String book;
  final int book_number;
  final int chapter;
  final int start_verse;
  final int end_verse;
  final bool is_valid;

  Reference(book, [chapter, start_verse, end_verse])
      : book = book,
        chapter = chapter,
        start_verse = start_verse,
        end_verse = end_verse,
        book_number = Librarian.findBook(book),
        reference =
            Librarian.createReference(book, chapter, start_verse, end_verse),
        is_valid = Librarian.verifyVerse(book);
}
