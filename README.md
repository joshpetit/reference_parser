# reference_parser
A dart package that parses strings for bible references

## Installation
Add `reference_parser: ^0.5.0` to your pubspec.yaml then run pub get in the project directory

## Usage
See `example/main.dart` for a look at the types of strings
that can be parsed
```dart
import 'package:reference_parser/reference_parser.dart';

var ref = parseString('Gen 1:1');
```

After importing and creating a reference object, you can
view the parsed information through the fields

```dart
var ref = parseString('Gen 1:1-5');

ref.book; //Genesis
ref.bookNumber; //1
ref.chapter; //1
ref.startVerse; //1
ref.endVerse; //5
ref.reference; //Genesis 1:1-5
ref.isValid; //true
```

Note that you can create non-existent references, so always
check the isValid field to ensure a reference is correct

You can also directly create reference objects by calling
`createReference(String book, [int chapter, int startVerse, int endVerse])`
```dart
var ref = createReference('1Co', 2);
print(ref.reference); //1 Corinthians 2
```

