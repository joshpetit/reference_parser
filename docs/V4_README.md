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

## API

```dart
var lexicon = BibleLexicon(
    locales: [
        BibleLexiconEN(
          bookForms: {
            // Adds "Matty B" as a mapping to the book of matthew
            "Matty B": BibleLexiconBooks.matthew,
          },
        ),
        BibleLexiconFR(
          bookForms: {
            // Adds "Matty B" as a mapping to the book of matthew
            "Matté B": BibleLexiconBooks.matthew,
          },
        ),
    ],
    defaultLocale: BibleLexiconEN.localeCode // The locale will default to English if not specified
);

var ref = lexicon.createReference(
  book: BibleBooks.GENESIS,
  startChapter: 1,
  startVerse: 1,
  endVerse: 2,
);

var ref = lexicon.createReference(
  book: lexicon.parseBookFromString("Matty B"),
  startChapter: 1,
  startVerse: 1,
  endVerse: 2,
);
print(ref.locale); // EN
print(ref.reference); // Matthew

ref.apocyphalBookNumber; // Whatever # book Matthew is in the apocrypha haha
var verses = ref.verses;

ref.containsMultipleVerses; // true
ref.containsMultipleChapters; // true

var ref = lexicon.createVerseReference(
  book: lexicon.parseBookFromString("Gen"),
  chapter: 1,
  verse: 1,
);

var ref = lexicon.createVerseRangeReference(
  book: lexicon.parseBookFromString("Gen"),
  chapter: 1,
  startVerse: 1,
  endVerse: 1,
  locale: BibleLexiconFR.localeCode,
);
print(ref.reference); // Genèse 1:1

var ref = lexicon.createChapterReference(
  book: lexicon.parseBookFromString("Gen"),
  chapter: 1,
);

var ref = lexicon.createChapterRangeReference(
  book: lexicon.parseBookFromString("Gen"),
  startChapter: 1,
  endChapter: 1,
);
```

I think for a good first thing, we can keep all the lexicon locales in one
package, and then if it starts getting too large we can just split them :). If
someone is doing bible related software though I can't imagine it all being too
large lol. Then in v5 we can split it into different packages if having more
would be required if there seems to be added value.

How about, instead of "locales" I call them "subLexicons." So lexicons are built
by their own definitions and then sublexicons if definitons are not found. I
suppose the hard thing about that is, what if I don't want to use English?

Or how about I call it "BibleLexemeFR" rather than LexiconFR. Or Just
BibleLanguageFR haha to keep things simple

```dart

var lexicon = BibleLexicon(
    formats: [
        BibleEN(
          bookForms: {
            // Adds "Matty B" as a mapping to the book of matthew
            "Matty B": BibleLexiconBooks.matthew,
          },
        ),
        BibleFR(
          bookForms: {
            // Adds "Matty B" as a mapping to the book of matthew
            "Matté B": BibleLexiconBooks.matthew,
          },
        ),
    ],
    defaultLocale: BibleLexiconEN.localeCode // The locale will default to English if not specified
);


```

I need to remember catholic bible has different number of chapters and stuff too
so I need to include last chapter in apocryphal things too

OK, because of song of solomons I don't think I can make the variants something
I include in parsing by default. (Or maybe I should 1 cor 16:13 and make a new
regex...). ASIGASIG. I'll have to figure out a way around that either way

## The apocrypha revisited...

ALRIGHT. So then. What if someone regards more than the Catholic Apocrypha as
scripture? Like 3+4 Macabees. All that other jazz. Maybe I could optionally
enable parsing things outside the Catholic canon. Kinda like book addons. Or I
can make every book parsing an addon of such? So for example...

```dart
var lexicon = BibleLexicon(
    formats: [
        BibleEN(
          bookForms: {
            // Adds "Matty B" as a mapping to the book of matthew
            "Matty B": BibleLexiconBooks.matthew,
          },
        ),
        BibleFR(
          bookForms: {
            // Adds "Matty B" as a mapping to the book of matthew
            "Matté B": BibleLexiconBooks.matthew,
          },
        ),
    ],
    // lollll controversial field name right there
    canon: BibleLexiconCanon.protestant, // default
    defaultLocale: BibleLexiconEN.localeCode
);
```

And BibleLexiconCanon.protestant would just be a list of the books typically
considered as scripture. But then you can mix+match them a bit.

```dart
var lexicon = BibleLexicon(
    formats: [
    //...
    ],
    canon: [
        BibleLexiconCanonBook.matthew,
    ],
    defaultLocale: BibleLexiconEN.localeCode
);

var lexicon = BibleLexicon(
    formats: [
    //...
    ],
    canon: BibleLexiconCanon.apocrypha,
    defaultLocale: BibleLexiconEN.localeCode
);
```

The cool thing about this is that you can enable/disable certain books from
being parsed. So if you, say, wanted to parse all the new testament books within
a string... But then again that's a small usecase since you could just parse all
the scriptures and filter out the ones that are not in the new testament.

This is still good nonetheless though because it makes the apocrypha selectively
parsed. So if you don't want the apocypha you don't have to have it!

After this, it also would be needed to make sure we define the correct book
number priority... Cuz if you only include on apopcryphal book, how does that
affect the ordering of other numbers?

I think that may merit a new field to reference called "parsedBookNumber." And
this would be the books position relative to what books you have configured as
cannon. so `canon: [BibleLexiconCanonBook.matthew]` would only parse matthew,
and the `parsedCannonBookNumber` would be 1 when matthew is parsed

```dart
class PassageReference {
    String book;

    /// The position realtive to the protestant cannon.
    int bookNumber;
    int startVerseNumber;
    int endVerseNumber;
    int startChapterNumber;
    int endChapterNumber;

    /// Whether this reference is found in the parsed canon
    bool isInParsedCannon;

    /// en, fr, etc.
    String locale;

    /// The position realtive to the Catholic cannon
    int apocryphalBookNumber;

    /// The position realtive to the books being parsed
    int parsedCannonBookNumber;
    /// Whether this reference is found in the apocryph but not in the
    /// protestant canon
    bool isApocryphal;

    /// The last chapter in this book within the apocrypha (Esther is diff)
    int apocryphalEndChapterNumber;

    /// The last verse in this book within the apocrypha (Esther is diff)
    int apocryphalEndVerseNumber;
}

```

So then I suppose the question would be, what would you gain from seeing the
booknumber within the protestant canon rather than the position of books
parsed as canon? Could we rather add another field that links to the enum, and
from that enum retrieve information about the position in the protestant canon,
catholic canon, etc.

So for example

```dart
reference = lexicon.createReference(book: BibleLexiconBooks.matthew);
print(reference.lexicalBook.protestantCanonNumber) // 40
print(reference.lexicalBook.catholicCanonNumber) // 47 I think
```

We can do the same thing for

Small implementation detail, but I think lexicalBook should be an enum. That way we can
do pattern matching to make sure every case is held. If it were to be an
interface then we wouldn't have a solid way to make sure everything is
exhaustively matched if the need were to arise... But then again I doubt there
will be a need to actually exhaustively match things. It may make the code a lot
easier to read if it were to be an interface. But implementation aside, the
consumer facing API is the most important.

OKKKKKKKK. But now I realized... How are we supposed to change the number of
chapters in Esther based on the canon. Well. DEFINE THE API figure out after.
But I think it'd likely be that when constructing the reference, we use the
context within the lexicon to set the number of chapters and what not. That
would likely also be used when creating the subdivisions (chapterReferences) so
that we can correctly generate the chapters.

# PUTTING IT ALL TOGETHER

The default API experience should look like:

```dart
var lexicon = BibleLexicon();
var reference = lexicon.createReference(
  book: BibleBooks.genesis,
  startChapter: 1,
  startVerse: 1,
  endChapter: 2,
  endVerse: 3,
);

// Separate methods to help construct verses as such
var reference = lexicon.createVerseReference(
  book: BibleBooks.luke,
  chapter: 1,
  verse: 3,
);

var greeting = switch(reference.referenceRange) {
 // Genesis 1:1
 ReferenceRange.verse => "Selected Verse",
 // Genesis 1:1-5, Genesis 1:1 - 2:5
 ReferenceRange.verse_range => "Selected Verses",
 ReferenceRange.chapter => "Selected Chapter",
 ReferenceRange.chapter_range => "Selected Chapters",
 ReferenceRange.book => "Selected book",
 // book_range_not_supported => y "would u want this lol",
};

print(reference.chapters); // [1]
print(reference.chapterReferences); // [PassageReference(book: "Luke", chapter: 1, startVerse: 1, endVerse: 64)]
print(reference.verses); // [3]
print(reference.verseReferences); // [PassageReference(book: "Luke", chapter: 1, startVerse: 3, endVerse: 3)]

print(reference.hasMultipleChapters); // false
print(reference.hasMultipleVerses); // false

print(reference.isValid); // true

var reference = lexicon.createVerseReference(
  book: BibleBooks.i_maccabees,
  chapter: 1,
  verse: 3,
);

// This defaults to the protestant lexicon
print(reference.isValid); // false

// Other canons to add are "easternOrthodox" which has 3&4 maccabees, psalm 151,
// etc.
var catholicLexicon = BibleLexicon(
    bibleCanon: BibleCanon.catholic
);

var reference = catholicLexicon.createVerseReference(
  book: BibleBooks.i_maccabees,
  chapter: 1,
  verse: 3,
);
// This defaults to the protestant lexicon
print(reference.isValid); // true

```
