part of 'translator.dart';

extension TextTranslatorExtension on String {
  Future<Translation> translate({String from = 'auto', String to = 'en'}) async {
    return await Translator().translate(this, from: from, to: to);
  }

  Future<String> t({String from = 'auto', String to = 'en'}) async {
    final trans = await translate(from: from, to: to);
    return trans.translated;
  }
}
