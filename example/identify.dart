import 'package:reference_parser/identification.dart';

void main() async {
  identifyReference("Come to me all").then((x) => {
        print(x[0]),
      });
}
