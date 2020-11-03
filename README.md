# reference_parser
A dart package that parses strings for bible references. You can parse single references or
multiple references from a string in a variety of formats.

## Installation
Add `reference_parser: ^0.5.0` to your pubspec.yaml then run pub get in the project directory

## Usage

to include the default exports of reference parser add this to your imports:
```dart
import package:reference_parser/reference_parser.dart`
```

### Single References
To parse a single reference from a string, call the `parseReference` function:

```dart
var ref = parseReference("I like Mat 2:4-10");
```

This will return a reference object containing the reference to 'Matthew 2:4-10'.

### Reference Objects
***(Prepare for the alliteration!)***

Reference objects are general references that can refer to either single verses, a range of verses,
a single chapter, or entire books.
```dart
ref.book // 'Matthew'
ref.bookNumber // 40
ref.chapter // 2
ref.isValid // true
ref.osis // 'Matt'
ref.abbr // 'MAT'
ref.short // 'Mt'
ref.reference // 'Matthew 2:4'-10
ref.referenceType // ReferenceType.RANGE
```
All of these fields are specific to the BibleReference class and its subclasses

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
firstVerse.referenceType // ReferenceType.RANGE
```
Since it inherits from the BibleReference class, it contains all the field mentioned
about reference objects (book, osis, abbreviation, reference, and so on).

This is useful when we start working with chapter and book references.

### Chapters
