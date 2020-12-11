# reference_parser

A dart package that parses strings for bible references. You can parse single references or
multiple references from a string in a variety of formats.

<!-- toc -->
  * [Installation](#installation)
- [Usage](#usage)
  * [Parsing References](#parsing-references)
  * [Identifying References](#identifying-references)
  * [Objects and References](#objects-and-references)
    + [Reference](#reference)
    + [Verses](#verses)
    + [Chapters](#chapters)
    + [Books](#books)
  * [Constructing References](#constructing-references)
    + [Invalid References](#invalid-references)
<!-- tocstop -->

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
This will create a list of References with 'Genesis 5:7' and '1 Corinthians 2'

**Note**: The word 'is' will be parsed as the book of Isaiah, this may not be the case in
future versions.

## Identifying References
The `identifyReference` method included in reference_parser will use [biblehub.com](https://biblehub.com)
to generate a list of possible bible references for a string. Make sure to import the
identification library `import 'package:reference_parser/identification.dart';`
For example:
```dart
import 'package:reference_parser/identification.dart';
//...
identifyReference("Come to me all ye").then((possibilities) => {
      print(possibilities[0]), // The most likely match would be at index 0
    });
```
This will return a future with a list of objects of type `ReferenceQuery` with the fields `x.query`, 
`x.reference`, and `x.preview`. The `x.reference` field will return a `Reference` object and
the other two are Strings. Check the API documentation for more information.

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
ref.toString() // 'Matthew 2:4-10'
ref.referenceType // ReferenceType.RANGE
```
All of these fields are specific to the BibleReference class and its subclasses

-------

### Verses
Verses are done a little differently to allow for more use-cases. For example, to retrieve
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
For this example, we will use
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
```dart
ref.startVerse.chapter // 5
ref.startVerse.verseNumber // 1
ref.endVerse.chapter // 5
ref.endVerse.verseNumber // 20
```

------

### Books

In this example, we will set ref to
```dart
ref = parseReference("Ecclesiastes is hard to spell");
```
This creates a [Reference] object of type `ReferenceType.BOOK`. One thing to note is that
there is no `chapter` class, so when the chapter is not specified it is initialized to null
```dart
ref.chapter // null
ref.ReferenceType // ReferenceType.CHAPTER
```
Verse objects are still created but with reference to the first verse in the book and the
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

## Constructing References

You can directly create all BibleReferences by calling their constructors
```dart
var ref = Reference("Mat", 2, 4);
var verse = Verse("Matt", 2, 4);
```
This creates `Reference` and `Verse` objects of 'Matthew 2:4'

```dart
ref = Reference("Mat", 2, 4, 10);
```
This creates a reference to 'Matthew 2:4-10'.

### Invalid References

All references have an `isValid` field that verifies if the book, chapter,
starting, and ending verse are all in the bible. For `Verse` objects, the book, chapter,
and verse number are verified.

```dart
ref = Reference("McDonald", 2, 4, 10);
```
This creates a reference to "McDonald 2:4-10". 
When an invalid book is passed in the constructor, the `isValid` property will be set to false, but
the fields that are passed in will still be initialized.
```dart
ref.reference // "McDonald 2:4-10"
ref.book // "McDonald"
ref.isValid // false
ref.startVerseNumber // 4
ref.endVerseNumber // 10
ref.osis // null (and so will be all other secondary book fields)
```

The same logic applies to chapters and verse numbers.
```dart
ref = Reference("Jude", 2, 10);
ref.isValid // false (Jude only has one chapter)
```
The startVerse and endVerse objects will also be created but their isValid field
will be initialized to false.
```dart
ref.startVerse.verseNumber // 10
ref.startVerse.isValid // false
```

