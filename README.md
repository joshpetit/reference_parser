# reference_parser
A dart package that parses strings for bible references. You can parse single references or
multiple references from a string in a variety of formats and also identify a text to
its potential match in the bible.

Really 99% of what you need to know will be found in the 
[Parsing References](#parsing-references) and [Identifying References](#identifying-references)
headers. But if you have more complicated needs this package can handle those!

<!-- toc -->
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
  * [Other Fun Stuff](#other-fun-stuff)
<!-- tocstop -->

# Usage

to include the default exports of reference parser add this to your imports:
```dart
import package:reference_parser/reference_parser.dart`
```

## Parsing References
use the `parseReference` function to retrieve a single reference:

```dart
var ref = parseReference("I like Mat 2:4-10 and John 3:1");
```
This will return a reference object describing 'Matthew 2:4-10'.

use the `parseAllReference` to retrieve all references within a string.

```dart
var refs = parseAllReferences('I enjoy reading Gen 5:7 and 1Co 2-3');
```
**Note**: The word 'is' will be parsed as the book of Isaiah.

## Identifying References
import the identification library with:

`import 'package:reference_parser/identification.dart';`

then identify references like this:
```dart
identifyReference("Come to me all ye").then((possibilities) => {
      print(possibilities[0]), // The most likely match would be at index 0
    });
```
The `identifyReference` method uses [biblehub.com](https://biblehub.com).
It will return a PassageQuery object that contains a Reference object along with
a preview of the verse and the original query.

## Objects and References

### Reference
Reference objects are the broadest kind of reference.
You can directly construct one by following this format:

```dart
var ref = Reference(book, [startChp, startVer, endChp, endVer]);
```
(for ease of use the `Reference` class has multiple named
constructorsr. Look [here](#constructing-references) and at the API reference.)

Their most important fields are these:
```dart
ref.reference // The string representation (osisReference, shortReference, and abbr also available)
ref.startVerseNumber
ref.endVerseNumber
ref.startChapterNumber
ref.endChapterNumber
ref.referenceType // VERSE, CHAPTER, VERSE_RANGE, CHAPTER_RANGE
```
Based on what is passed in, the constructor will figure out
certain fields. For example, if you were to construct `Reference('James')`
the last chapter and verse numbers in James will be initialized accordingly.

There are many other fields that may prove useful such as 
ones that subdivid the reference, look [here](#other-fun stuff)

-------

### Verses

`Reference` objects have a `startVerse` and `endVerse` field
that return objects of the Verse type.
```dart
var firstVerse = ref.startVerse;
var randomVerse = Verse(book, chapter, verse);
```

You can also construct `Reference`s that 'act' like
verses by using the named constructor
```dart
var ref = Reference.verse(book, chapter, verse);
```

------

### Chapters
```dart
ref = parseReference("James 5 is a chapter");
```
The `ref` object now holds a `Reference` to "James 5". Despite this, startVerseNumber and endVerseNumber are initialized to the first and last verses in James 5. 
```dart
ref.startVerseNumber // 1
ref.endVerseNumber // 20
ref.referenceType // ReferenceType.CHAPTER
```

The Reference object also has start/end chapter fields
```dart
var ref = parseReference('James 5-10 is cool');
ref.startChapterNumber // 5
ref.endChapterNumber // 10
```

Just like verses you can create chapter objects:

```dart
var chp = Chapter(book, chapter);
```
------

### Books
```dart
var ref = parseReference("Ecclesiastes is hard to spell");
ref.startChapterNumber // 1
ref.endChapterNumber // 12
ref.ReferenceType // ReferenceType.BOOK
```
Books don't have their own class, they're the equivalent of
a `Reference` object.

## Constructing References

### Verses
```dart
var ref = Reference("Mat", 2, 4);
var ref = Reference.verse("Mat", 2, 4);
var verse = Verse("Matt", 2, 4);
```
Note that the `verse` object has different fields than a
`Reference` object. Check the API.

### Verse Ranges
```dart
ref = Reference("Mat", 2, 4, null, 10);
ref = Reference.verseRange("Mat", 2, 4, 10);
```
These are equivalents that create a reference to 'Matthew 2:4-10'.

The same constructors and classes apply for chapters.

### Invalid References
All references have an `isValid` field that says whether this reference
is within the bible.

```dart
var ref = Reference("McDonald", 2, 4, 10);
print(ref.isValid) // false, as far as I know at least.
```
**Notice that the other fields are still initialized!!** So if needed, make
sure to check that a reference is valid before using it.
```dart
ref.reference // "McDonald 2:4-10"
ref.book // "McDonald"
ref.startVerseNumber // 4
ref.osisBook // null, and so will be other formats.
```

The same logic applies to chapters and verse numbers.
```dart
ref = Reference("Jude", 2, 10);
ref.isValid // false (Jude only has one chapter)
```
## Other fun stuff
I made this library bloat so it can do a lot haha.
```dart
ref.verses // returns a list of verse objects within this reference. There's Also one for chapters.
ref.chapters // each chapter
ref.osisReference // the osis representation (there's also short, and abbr)
```
