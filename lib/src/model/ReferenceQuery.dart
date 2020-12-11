import 'package:reference_parser/src/model/Reference.dart';

class ReferenceQuery {
  final String query;
  final Reference reference;
  final String preview;

  ReferenceQuery(this.query, this.preview, this.reference);

  String toString() {
    return "${reference} - ${preview}";
  }
}
