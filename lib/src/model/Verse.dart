import 'package:reference_parser/src/util/VerseEnum.dart';

class Verse {
  final String reference;
  final String book;
  final int chapter;
  final int verseNumber;
  final ReferenceType verseType;
  Verse(this.reference, this.book, this.chapter, this.verseNumber,
      this.verseType);
}
