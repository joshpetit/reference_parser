import 'dart:convert';
import 'package:reference_parser/src/parsers/parser.dart';
import 'package:reference_parser/src/model/ReferenceQuery.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:html/dom.dart';

/// Identify possible references to Strings
///
/// Calling this method will return a Future of
/// [ReferenceQuery] objects. If there are no possible
/// matches found then the list will be empty.
/// ```
/// identifyReference("Come to me all ye who").then((x) => {
///        print(x[0]),
///      });
/// ```
Future<List<ReferenceQuery>> identifyReference(String text) async {
  final params = {'q': text};
  final uri = Uri.https('biblehub.net', '/search.php', params);
  final res = await http.get(uri);
  var doc = parse(res.body);
  List<Element> l = doc.querySelectorAll('#leftbox > div > p > a > span.l');
  var queries = <ReferenceQuery>[];
  for (int i = 0; i < l.length; i++) {
    var ref = parseReference(l[i].text.trim());
    var len = ref.reference.length;
    var preview = l[i].text.substring(len + 1).trim();
    if (preview.substring(0, 1) != '/') {
      queries.add(ReferenceQuery(text, preview, ref));
    }
  }
  return queries;
}
