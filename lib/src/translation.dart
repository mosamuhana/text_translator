part of 'translator.dart';

class Translation {
  final String translated;
  final String source;
  final TranslationLanguage to;
  final TranslationLanguage from;

  Translation._(this.translated, this.source, this.from, this.to);

  String operator +(dynamic other) => translated + (other == null ? '' : other.toString());

  @override
  String toString() => translated;
}
