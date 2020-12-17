import 'package:reference_parser/src/parsers/parser.dart';
import 'package:reference_parser/src/model/ReferenceQuery.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'dart:async';

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
  final uri = Uri.https('biblescan.com', '/search.php', params);
  final res = await http.get(uri);
  var doc = parse(res.body);
  var l = doc.querySelectorAll(
      '#leftbox > div.results > div.result_block, div.result_altblock');
  var queries = <ReferenceQuery>[];
  for (var i = 0; i < l.length; i++) {
    var text = l[i].querySelector('a').text;
    var ref = parseReference(text);
    var len = ref.reference.length;
    var preview = text.substring(len + 1).trim();
    if (preview.substring(0, 1) != '/') {
      queries.add(ReferenceQuery(text, preview, ref));
    }
  }
  return queries;
}
