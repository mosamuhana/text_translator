import 'dart:async';
import 'dart:convert' show jsonDecode;

import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

import 'generate_token.dart';

part 'translation.dart';
part 'language.dart';
part 'extensions.dart';
part 'utils.dart';

class Translator {
  static Translator? _instance;
  static List<TranslationLanguage>? _languages;
  factory Translator() => _instance ??= Translator._();
  Translator._();

  static List<TranslationLanguage> get languages =>
      _languages ??= _langMap.entries.map((e) => TranslationLanguage._(e.key, e.value)).toList();

  Future<Translation> translate(
    String source, {
    String from = _defaultFrom,
    String to = _defaultTo,
    ClientType client = ClientType.t,
    String baseUrl = _defaultBaseUrl,
  }) async {
    try {
      return await _apiTranslate(
        source: source,
        from: from,
        to: to,
        client: client,
        baseUrl: baseUrl,
      );
    } catch (e) {
      return await _htmlTranslate(
        source: source,
        from: from,
        to: to,
      );
    }
  }

  Future<Translation> _apiTranslate({
    required String source,
    required String from,
    required String to,
    ClientType client = ClientType.t,
    String baseUrl = _defaultBaseUrl,
  }) async {
    final toLang = _getLanguage(to);
    var fromLang = _getLanguage(from);

    final query = <String, String>{
      'client': client == ClientType.t ? 't' : 'gtx',
      'sl': fromLang.code,
      'tl': toLang.code,
      'hl': toLang.code,
      'dt': 't',
      'ie': 'UTF-8',
      'oe': 'UTF-8',
      'otf': '1',
      'ssel': '0',
      'tsel': '0',
      'kc': '7',
      'tk': generateToken(source),
      'q': source
    };

    var url = Uri.https(baseUrl, '/translate_a/single', query);
    final data = await _getRequestAsJson(url);

    final List translations = data[0];
    final sb = StringBuffer();

    for (var t in translations) {
      sb.write(t[0]);
    }

    if (fromLang.isAuto && fromLang.code != toLang.code) {
      from = data[2] ?? fromLang.code;
      if (from == toLang.code) {
        from = 'auto';
        fromLang = _getLanguage(from);
      }
    }

    return Translation._(sb.toString(), source, fromLang, toLang);
  }

  Future<Translation> _htmlTranslate({
    required String source,
    required String from,
    required String to,
  }) async {
    final fromLang = _getLanguage(from);
    final toLang = _getLanguage(to);

    final query = {
      'sl': fromLang.code,
      'tl': toLang.code,
      'q': source,
    };
    final url = Uri.https("translate.google.com", "/m", query);
    final body = await _getRequestAsString(url);
    final translated = _parseHtmlTranslate(body);

    return Translation._(translated, source, fromLang, toLang);
  }
}

enum ClientType { t, gtx }

const String _defaultBaseUrl = 'translate.googleapis.com';
const String _defaultFrom = 'auto';
const String _defaultTo = 'en';
