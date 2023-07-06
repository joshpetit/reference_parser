# Version 4

This version has a few gotchas that I would like to improve upon. For example:

- We completely left out people that need apocryphal references
- Some people may want to add more abbreviations for certain books
- The "Reference" API is a little... difficult. It makes sense with parameter
  inlay hints, but would have been better with named parameters
- I would love to do it without inheritance.
  I've grown tired of inheritance and using composition has helped make
  code a lot clearer to reason about.
- The documentation for what "osis" and other things are could've been better.
- The web scrapper, while cool, adds a dependency that isn't needed for the core
  parsing, it would be better off as a library
  off as its own package.

## API considerations

```dart
var ref = PassageReference(
  book: BibleBooks.GENESIS,
  startChapter: 1,
  startVerse: 1,
  endVerse: 2,
);

var ref = PassageReference(
  book: BibleBooks.fromString("Gen"),
  startChapter: 1,
  startVerse: 1,
  endVerse: 2,
);

ref.apocyphalBookNumber;
var verses = ref.verses;
verses[0].referenc; // Genesis 1:1
verses[0].chapter; // 1

ref.containsMultipleVerses;
ref.containsMultipleChapters;

var ref = PassageReference.verse(
  book: BibleBooks.fromString("Gen"),
  chapter: 1,
  verse: 1,
);

var ref = PassageReference.verseRange(
  book: BibleBooks.fromString("Gen"),
  chapter: 1,
  startVerse: 1,
  endVerse: 1,
);

var ref = PassageReference.chapter(
  book: BibleBooks.fromString("Gen"),
  chapter: 1,
);

var ref = PassageReference.chapterRange(
  book: BibleBooks.fromString("Gen"),
  startChapter: 1,
  endChapter: 1,
);
```

So I like this, but the sucky thing is that it doesn't make a clear an easy way
to localize the book references. This may be good for a first version, but if I
want to in the future support other languages and keep the package reasonably
sized, I'd have to make some kind of way to plug in more parsing things that
also work with localization.

```dart
var bibleThing = BibleThing(
    locales: [
        BibleThingEnglish(),
        BibleThingFrench(),
    ]
);

var ref = bibleThing.createReference(
  book: BibleBooks.fromString("Gen"),
  startChapter: 1,
  startVerse: 1,
  endVerse: 2,
);
```

So we also want to be able to display the created reference based on locale. So
the parsed reference will display in the local that it was parsed from

```dart

var ref = bibleThing.createReference(
  locale: BibleThingFrench.localeCode,
  book: BibleBooks.MATTHEW,
  startChapter: 2,
);

ref.reference; // Matthieu 2

var englishRef = ref.inLocale(BibleThingEnglish.localeCode);
englishRef.reference; // Matthew 2
```

Being able to add your own identifiers for books would be nice

```dart
var bibleThing = BibleThing(
  locales: [
    BibleThingEnglish(
      bookForms: {
        {
          "Matty B": BibleBooks.MATTHEW,
        }
      }
    ),
  ],
);
```

Maybe BibleBooks should be moved to the BibleThing class so that we can make the
fromString work per locale.

Another note, is that I want this all to work super simply from an overview, so
that it's very easy to get started. To the point where you just create the thing
object and can just get started parsing

```dart
var parsedRef = bibleThing.parseReference("Matthieu 2:4");
print(parsedRef.reference); // "Matthieu 2:4"
print(parsedRef.toLocale(BibleThingEnglish.localeCode).reference); // "Matthew 2:4"
```
