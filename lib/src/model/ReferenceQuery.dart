import 'package:reference_parser/src/model/Reference.dart';

/// A query object returned by the [identifyReference()] function.
///
/// The [preview] field contains a shortened portion of the verse.
/// ```
/// var refs = await identifyReference("This is what");
/// var ref = refs[0];
/// print(ref.preview) // "This is what the LORD says: "Heaven is my throne, and the earth is my footstool. ..."
/// print(ref.query) // "This is what"
/// print(ref.reference.reference) // "Isaiah 66:1"
/// ```
///
/// *Note*, the [reference] field will be a [Reference] object, not a String.
class ReferenceQuery {
  final String query;
  final Reference reference;
  final String preview;

  ReferenceQuery(this.query, this.preview, this.reference);

  @override
  String toString() {
    return '${reference} - ${preview}';
  }
}
