import 'package:reference_parser/reference_parser.dart';

void main() {
  //Parse Reference
  var ref = parseReference('Jn 3:16');
  print(ref.book); //'John'
  print(ref.bookNumber); //43
  print(ref.chapter); //3
  print(ref.startVerse); //16
  print(ref.isValid); //true

  ref = parseReference('1john 4:5');
  print(ref.book); //'1 John'

  //Variant Spellings
  ref = parseReference('Songs 2:1');
  print(ref.reference); //'Song of Solomon 2:1'

  //Range of verses
  ref = parseReference('Gen 4:5-10');
  print(ref.reference); //'Genesis 4:5-10'
  print(ref.startVerse); //5
  print(ref.endVerse); //10

  //Book and chapter references
  ref = parseReference('Ps 1');
  print(ref.reference); //'Psalms 1'

  //Book References
  ref = parseReference('gn');
  print(ref.reference); //'Genesis'

  //Validation
  ref = parseReference('Joe 2:4');
  print(ref.book); //Joe
  print(ref.bookNumber); //null
  print(ref.isValid); //false

  ref = parseReference('Genesis 1:100');
  print(ref.isValid); //false

  //Create Reference
  ref = createReference('1co', 3, 4, 5);
  print(ref.book); //'1 Corinthians'
  print(ref.chapter); //3
  print(ref.startVerse); //4
  print(ref.endVerse); //5
}
