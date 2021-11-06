part of 'translator.dart';

Future<String> _getRequestAsString(Uri url) async {
  final client = RetryClient(http.Client());
  try {
    final response = await client.get(url);
    if (response.statusCode != 200) {
      throw http.ClientException('Error ${response.statusCode}: ${response.body}', url);
    }
    return response.body;
  } catch (e) {
    rethrow;
  } finally {
    client.close();
  }
}

Future<dynamic> _getRequestAsJson(Uri url) async {
  final content = await _getRequestAsString(url);
  final data = jsonDecode(content);
  if (data == null || data is! List) {
    throw http.ClientException("Error: Can't parse json data");
  }
  return data;
}

String _parseHtmlTranslate(String contents) {
  const divStart = '<div class="result-container">';
  //print("$contents : ${contents.length}");
  final startIndex = contents.indexOf(divStart);
  //print("startIndex : $startIndex");
  final endIndex = contents.indexOf("</div>", startIndex + divStart.length);
  //print("endIndex : $endIndex");
  return contents.substring(startIndex + divStart.length, endIndex);
}
