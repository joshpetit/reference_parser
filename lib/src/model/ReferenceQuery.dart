import 'package:reference_parser/src/model/Reference.dart';

/// A query object returned by the [identifyReference()] function.
///
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
  /// The query passed by the [identifyReference()] parameter.
  final String query;

  /// The [Reference] object that possibly matches the query.
  final Reference reference;

  /// This field contains a shortened portion of the verse's text.
  final String preview;

  /// Constructs a query object with returned text,
  /// preview and reference.
  ReferenceQuery(this.query, this.preview, this.reference);

  /// [reference] - [preview].
  @override
  String toString() {
    return '${reference} - ${preview}';
  }
}
