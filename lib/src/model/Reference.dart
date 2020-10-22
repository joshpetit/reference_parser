import 'package:reference_parser/src/data/Librarian.dart';
import 'package:reference_parser/src/model/Verse.dart';

import 'package:reference_parser/src/util/VerseEnum.dart';

class Reference {
  final String reference;
  final String book;
  final int bookNumber;
  final int chapter;
  final int startVerseNumber;
  final Verse startVerse;
  final int endVerseNumber;
  final Verse endVerse;
  final ReferenceType referenceType;
  final bool isValid;

  Reference(book, [chp, svn, evn])
      : book = book,
        chapter = chp ?? 1,
        startVerseNumber = svn ?? 1,
        startVerse = svn != null
            ? Verse(book, chp, svn)
            : chp != null
                ? Verse(book, chp, 1)
                : Verse(book, 1, 1),
        endVerseNumber = evn ?? svn ?? Librarian.getLastVerseNumber(book, chp),
        endVerse = evn != null
            ? Verse(book, chp, evn)
            : svn != null
                ? Verse(book, chp, svn)
                : Librarian.getLastVerse(book, chp),
        bookNumber = Librarian.findBook(book),
        reference = Librarian.createReferenceString(book, chp, svn, evn),
        referenceType = Librarian.identifyReferenceType(book, chp, svn, evn),
        isValid = Librarian.verifyVerse(book, chp, svn) &&
            Librarian.verifyVerse(book, chp, evn);
  @override
  String toString() {
    return reference;
  }
}
