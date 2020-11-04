# reference_parser
A dart package that parses strings for bible references. You can parse single references or
multiple references from a string in a variety of formats.

## Installation
Add `reference_parser: ^1.0.0` to your pubspec.yaml then run pub get in the project directory

# Usage

to include the default exports of reference parser add this to your imports:
```dart
import package:reference_parser/reference_parser.dart`
```

## Parsing References
To parse a single reference from a string, call the `parseReference` function:

```dart
var ref = parseReference("I like Mat 2:4-10 and John 3:1");
```
This will return a reference object containing the reference to 'Matthew 2:4-10'.

To parse all the references within a string and return a `List<Reference>`, call the
`parseAllReferences` function:

```dart
var refs = parseAllReferences('I enjoy reading Gen 5:7 and 1Co 2');
```
This will create a list of [Reference]s with 'Genesis 5:7' and '1 Corinthians 2'

----------

## Objects and References

### Reference
***(Prepare for the alliteration!)***

Reference objects are general references that can refer to either a single verse, a range of verses,
a single chapter, or entire an entire book. They extend the BibleReference class so include these base fields:
```dart
ref.book // 'Matthew'
ref.bookNumber // 40
ref.chapter // 2
ref.isValid // true
ref.osis // 'Matt'
ref.abbr // 'MAT'
ref.short // 'Mt'
ref.reference // 'Matthew 2:4-10'
ref.referenceType // ReferenceType.RANGE
```
All of these fields are specific to the BibleReference class and its subclasses

-------

### Verses
Verses are done a little differently to allow for more usecases. For example, to retrieve
the first/last verse in a given reference you can use the `[start/end]VerseNumber` field.

So for our 'Matthew 2:4-10' example:
```dart
ref.startVerseNumber // 4
ref.endVerseNumber // 10, note this will equal 4 if the reference was Matthew 2:4
```

But there are also [start/end]Verse fields available that return `Verse` objects.
```dart
var firstVerse = ref.startVerse;
```

This object contains the reference to Matthew 2:4
```dart
firstVerse.verseNumber // 4
firstVerse.chapter // 2
...
firstVerse.referenceType // ReferenceType.VERSE, all verse objects have the VERSE [ReferenceType]
```
Since it inherits from the BibleReference class, it contains all the fields mentioned
about reference objects (book, osis, abbreviation, reference, and so on).

This is useful when we start working with chapter and book references.

------

### Chapters
For this example we will use
```dart
ref = parseReference("James 5 is a chapter");
```
The `ref` object now holds a [Reference] to "James 5" because the starting and ending verses were
not specified. Despite this, however, startVerseNumber and endVerseNumber are initialized to
the first and last verses in James 5.
```dart
ref.startVerseNumber // 1
ref.endVerseNumber // 20
ref.referenceType // ReferenceType.CHAPTER
```
In addition to this, the corresponding `[start/end]Verse` objects are initialized to the
first and last verses of the chapter.

------

### Books
In this example we will set ref to
```dart
ref = parseReference("Ecclesiastes is hard to spell");
```
This creates a [Reference] object of type ReferenceType.BOOK. One thing to note is that
there is no `chapter` class, so when the chapter is not specified it is initialized to null
```dart
ref.chapter // null
```
Verse objects are still created however with reference to the first verse in the book and the
last verse in the book.
```dart
ref.startVerse // An object refering to 'Ecclesiastes 1:1'
ref.endVerse // An object refering to 'Ecclesiastes 5:14', the last verse in Ecclesiastes
ref.endVerse.chapter // 5
ref.endVerse.verseNumber // 14
```
The [start/end]VerseNumber fields in `ref` will still refer to the first and last verse numbers
within Ecclesiastes
```dart
ref.startVerseNumber // 1
ref.endVerseNumber // 14
```
------
