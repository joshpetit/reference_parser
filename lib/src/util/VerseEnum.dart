/// The kind of reference a [BibleReference] is.
enum ReferenceType {
  /// A reference that contains a
  /// book, chapter, and single verse.
  ///
  /// Genesis 2:3 for example. Generally associated
  /// with the [Verse] class.
  VERSE,

  /// A reference that contains a
  /// book, chapter, and multiple verses within
  /// the same chapter.
  ///
  /// For example, Genesis 2:2-4 is a
  /// verse range but not Genesis 2:2 - 3:5,
  /// this is an example of a [CHAPTER_RANGE].
  VERSE_RANGE,

  /// A reference that contains a
  /// book and a chapter.
  ///
  /// Genesis 2 is an example. Generally associated
  /// with the [Chapter] class.
  CHAPTER,

  /// A reference that spans multiple chapters.
  ///
  /// Genesis 2-3 or Genesis 2:3 - 2:5 are examples
  /// of chapter ranges.
  CHAPTER_RANGE,

  RANGE,

  /// A reference that contains
  /// only a book.
  ///
  /// Genesis for example.
  BOOK
}
